#include "TaskSqlModel.h"

//used stackoverflow for some guidance with this class http://stackoverflow.com/questions/14613824/qsqltablemodel-inheritor-and-qtableview
TaskSqlModel::TaskSqlModel(QObject *parent) : QSqlRelationalTableModel(parent)
{
    this->setEditStrategy(QSqlRelationalTableModel::OnFieldChange);
    this->setJoinMode(QSqlRelationalTableModel::LeftJoin);
}

void TaskSqlModel::applyRoles()
{
    roles.clear();

    for(int i = 0; i < this->columnCount(); i++)
    {
        QString role = this->headerData(i, Qt::Horizontal).toString();
        roles[Qt::UserRole + i + 1] = QVariant(role).toByteArray();
        //qDebug() << "apply role:" << this->headerData(i, Qt::Horizontal).toString() << i << (Qt::UserRole + i + 1);
    }
}

QVariantList TaskSqlModel::parameterNames()
{
    QVariantList names;

    for(int i = 0; i < this->columnCount(); i++)
    {
        QString role = this->headerData(i, Qt::Horizontal).toString();
        names.append(role);
    }
    return names;
}

// ------------------------------------------------------------------------------------ Invokables for Table

bool TaskSqlModel::setupModel(const QString &table, QString relatedTableName, QString replaceColumn, QString displayColumn)
{
    QSqlError err;

    this->setTable(table);
    err = this->lastError();
    if(err.type() != QSqlError::NoError)
    {
        qCritical() << err.text();
        return false;
    }

    if(!relatedTableName.isEmpty())
    {
        int field = this->fieldIndex(replaceColumn);
        this->setRelation(field, QSqlRelation(relatedTableName, this->headerData(0, Qt::Horizontal).toString(), displayColumn));
        err = this->lastError();
        if(err.type() != QSqlError::NoError)
        {
            qCritical() << err.text();
            return false;
        }
        this->relationModel(field)->setEditStrategy(QSqlTableModel::OnFieldChange);
        //qDebug() << "relational table was created" << relatedTableName << replaceColumn << displayColumn << field;
    }

    this->applyRoles();

    this->select();
    err = this->lastError();
    if(err.type() != QSqlError::NoError)
    {
        qCritical() << err.text();
        return false;
    }
    return true;
}

QVariant TaskSqlModel::data(const QModelIndex &index, int role) const
{
    if(role < Qt::UserRole)
    {
        return QSqlQueryModel::data(index, role);
    }

    int colIndex = role - Qt::UserRole - 1;
    QModelIndex modelIndex = this->index(index.row(), colIndex);

    return QSqlRelationalTableModel::data(modelIndex);
}

bool TaskSqlModel::insertNewRecord(QVariantMap defaultTaskMap)
{
    QSqlRecord record = this->record();
    QSqlRecord newRecord = recordFromMap(defaultTaskMap, record);
    bool success = QSqlRelationalTableModel::insertRecord(-1, newRecord);
    return success;
}

bool TaskSqlModel::setDataValue(int row, QString roleName, const QVariant &value)
{
    int role = roleNames().key(roleName.toUtf8()) - Qt::UserRole - 1;
    QModelIndex ind = this->index(row, role);
    bool success = QSqlTableModel::setData(ind, value);
    //qDebug() << "setDataValue" << success << this->lastError();
    return success;
}

bool TaskSqlModel::removeRows(int row, int count, const QModelIndex &parent)
{
    bool success = false;

    success = QSqlRelationalTableModel::removeRows(row, count, parent);

    for(int i = 0; i < this->columnCount(); i++)
    {
        QSqlTableModel *relatedModel = this->relationModel(i);

        if(relatedModel != NULL && relatedModel != 0)
        {
            for(int j = 0; j < relatedModel->rowCount(); j++)
            {
                QVariant id = this->data(this->index(row, 0), 0);
                QVariant taskId = relatedModel->data(relatedModel->index(j, 1));

                if(taskId == id)
                {
                    success = relatedModel->removeRows(j, 1, parent);
                }
            }
        }
    }

    return success;
}

// ------------------------------------------------------------------------------------ Invokables for Relational Table

QVariantList TaskSqlModel::relatedData(int index, QString relatedTableColumn) const
{
    QVariantList relatedData;

    int field = this->fieldIndex(relatedTableColumn);
    QSqlTableModel *relatedModel = this->relationModel(field);

    if(relatedModel != NULL)
    {
        for(int i = 0; i < relatedModel->rowCount(); i++)
        {
            QVariant id = this->data(this->index(index, 0), Qt::UserRole + 1);
            QVariant taskId = relatedModel->data(relatedModel->index(i, 1));

            if(taskId == id)
            {
                QVariantMap row;

                for(int j = 0; j < relatedModel->columnCount(); j++)
                {
                    QModelIndex ind = relatedModel->index(i,j);
                    QString role = relatedModel->headerData(j, Qt::Horizontal).toString();
                    row.insert(role, relatedModel->data(ind));
                }
                relatedData.append(row);
            }
        }
    }

    return relatedData;
}

bool TaskSqlModel::insertNewRelatedRecord(int index, QString tableColumn, QString relatedTableColumn, QVariantMap defaultTaskMap, int relatedRowCount, QString relatedTaskId)
{
    bool success = false;
    int field = this->fieldIndex(relatedTableColumn);
    QSqlTableModel *relatedModel = this->relationModel(field);

    if(relatedModel != NULL)
    {
        QSqlRecord record = relatedModel->record();
        QSqlRecord newRecord = recordFromMap(defaultTaskMap, record);

        QModelIndex ind = this->index(index, 0);
        int role = Qt::UserRole + 1;
        QVariant value = this->data(ind, role);

        newRecord.setValue(relatedTaskId, value);
        newRecord.setGenerated(relatedTaskId, true);
        newRecord.setValue(relatedTableColumn, relatedRowCount+1);
        newRecord.setGenerated(relatedTableColumn, true);

        success = relatedModel->insertRecord(-1, newRecord);
        if(success) success = relatedModel->select();
        if(success) this->setDataValue(index, tableColumn, relatedRowCount+1);
    }
    return success;
}

bool TaskSqlModel::setRelatedDataValue(int index, QString relatedTableColumn, int row, QString roleName, const QVariant &value)
{
    bool success = false;
    int field = this->fieldIndex(relatedTableColumn);
    QSqlTableModel *relatedModel = this->relationModel(field);

    int countRows = 0;

    if(relatedModel != NULL)
    {
        for(int i = 0; i < relatedModel->rowCount(); i++)
        {
            QVariant id = this->data(this->index(index, 0), Qt::UserRole + 1);
            QVariant taskId = relatedModel->data(relatedModel->index(i, 1));

            if(taskId == id)
            {
                if(countRows == row)
                {
                    for(int j = 0; j < relatedModel->columnCount(); j++)
                    {
                        QString role = relatedModel->headerData(j, Qt::Horizontal).toString();
                        if(roleName == role)
                        {
                            QModelIndex ind = relatedModel->index(i, j);
                            success = relatedModel->setData(ind, value);
                            //qDebug() << "set related model data" << ind.row() << ind.column() << value << success;
                        }
                    }
                }
                countRows++;
            }
        }
    }
    return success;
}

bool TaskSqlModel::removeRelatedRow(int index, QString tableColumn, QString relatedTableColumn, int row, int relatedRowCount, const QModelIndex &parent)
{
    bool success = false;
    int field = this->fieldIndex(relatedTableColumn);
    QSqlTableModel *relatedModel = this->relationModel(field);

    int countRows = 0;

    if(relatedModel != NULL)
    {
        for(int i = 0; i < relatedModel->rowCount(); i++)
        {
            QVariant id = this->data(this->index(index, 0), Qt::UserRole + 1);
            QVariant taskId = relatedModel->data(relatedModel->index(i, 1));

            if(taskId == id)
            {
                if(countRows == row)
                {
                    success = relatedModel->removeRows(i, 1, parent);
                }
                countRows++;
            }
        }
        if(success) this->setDataValue(index, tableColumn, relatedRowCount-1);
    }

    return success;
}

// ------------------------------------------------------------------------------------ Private Functions

QSqlRecord TaskSqlModel::recordFromMap(QVariantMap dataMap, QSqlRecord record)
{
    QMapIterator<QString, QVariant> i(dataMap);

    while(i.hasNext())
    {
        i.next();
        record.setValue(i.key(), i.value());
        record.setGenerated(i.key(), true);
    }

    return record;
}
