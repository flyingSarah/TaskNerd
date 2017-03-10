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

bool TaskSqlModel::setupModel(const QString &table, QString relatedTabelName, QString replaceColumn, QString displayColumn)
{
    QSqlError err;

    this->setTable(table);
    err = this->lastError();
    if(err.type() != QSqlError::NoError)
    {
        qCritical() << err.text();
        return false;
    }

    if(!relatedTabelName.isEmpty())
    {
        int field = this->fieldIndex(replaceColumn);
        this->setRelation(field, QSqlRelation(relatedTabelName, this->headerData(0, Qt::Horizontal).toString(), displayColumn));
        err = this->lastError();
        if(err.type() != QSqlError::NoError)
        {
            qCritical() << err.text();
            return false;
        }
        qDebug() << "relational table was created" << relatedTabelName << replaceColumn << displayColumn << field;
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

bool TaskSqlModel::setDataValue(int row, QString roleName, const QVariant &value)
{
    int role = roleNames().key(roleName.toUtf8()) - Qt::UserRole - 1;
    QModelIndex ind = this->index(row, role);
    bool success = QSqlTableModel::setData(ind, value);//this->setData(ind, value);
    //qDebug() << "set data value:" << this->tableName() << row << roleName << value << success << this->lastError();
    return success;
}

bool TaskSqlModel::insertNewRecord(int row, QVariantMap defaultTaskMap)
{
    QSqlRecord newRecord = recordFromMap(row, defaultTaskMap);
    bool success = QSqlRelationalTableModel::insertRecord(row, newRecord);
    return success;
}

bool TaskSqlModel::removeRows(int row, int count, const QModelIndex &parent)
{
    return QSqlRelationalTableModel::removeRows(row, count, parent);
}

QSqlRecord TaskSqlModel::recordFromMap(int row, QVariantMap dataMap)
{
    QSqlRecord record = this->record(row);
    QMapIterator<QString, QVariant> i(dataMap);

    while(i.hasNext())
    {
        i.next();
        record.setValue(i.key(), i.value());
        record.setGenerated(i.key(), true);
    }

    return record;
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

QVariantMap TaskSqlModel::getDataMap(int index, QString relatedTabelColumn) const
{
    QVariantMap dataMap;
    QVariantMap taskDataMap;

    int field = this->fieldIndex(relatedTabelColumn);
    QSqlTableModel *relatedModel = this->relationModel(field);

    for(int i = 0; i < this->columnCount(); i++)
    {
        QModelIndex ind = this->index(index, i);
        int role = Qt::UserRole + i + 1;
        QString key = this->headerData(i, Qt::Horizontal).toString();
        QVariant value = this->data(ind, role);

        if(key == relatedTabelColumn && relatedModel != NULL)
        {
            value = relatedModel->rowCount();
        }
        taskDataMap.insert(key, value);
    }
    dataMap.insert(this->tableName(), taskDataMap);

    if(relatedModel != NULL)
    {
        QVariantMap relationMap;
        //dataMap.value(this->tableName()).toMap().insert(relatedTabelColumn, relatedModel->rowCount());
        for(int i = 0; i < relatedModel->rowCount(); i++)
        {
            for(int j = 0; j < relatedModel->columnCount(); j++)
            {
                QModelIndex ind = relatedModel->index(i,j);

                //qDebug() << "relation model" << i << j << relatedModel->data(ind,j);
            }
        }
        dataMap.insert(relatedModel->tableName(), relationMap);
    }
    //qDebug() << "dataMap for:" << index << "\n  " << dataMap;

    return dataMap;
}
