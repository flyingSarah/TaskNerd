#include "TaskSqlModel.h"

//used stackoverflow for some guidance with this class http://stackoverflow.com/questions/14613824/qsqltablemodel-inheritor-and-qtableview
TaskSqlModel::TaskSqlModel(QObject *parent) : QSqlTableModel(parent)
{
    this->setEditStrategy(QSqlTableModel::OnFieldChange);
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

void TaskSqlModel::setupModel(const QString &table)
{
    this->setTable(table);
    this->applyRoles();
    this->select();
}

bool TaskSqlModel::setRecord(int row, QVariantMap taskDataMap)
{
    QSqlRecord record = recordFromMap(row, taskDataMap);
    bool success = QSqlTableModel::setRecord(row, record);

    return success;
}

bool TaskSqlModel::insertNewRecord(int row, QVariantMap defaultTaskMap)
{
    QSqlRecord newRecord = recordFromMap(row, defaultTaskMap);
    bool success = QSqlTableModel::insertRecord(row, newRecord);

    return success;
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
    QVariant value = QSqlTableModel::data(modelIndex);
    return value;
}

QVariantMap TaskSqlModel::getDataMap(int index) const
{
    QVariantMap dataMap;

    for(int i = 0; i < this->columnCount(); i++)
    {
        QModelIndex ind = this->index(index, i);
        int role = Qt::UserRole + i + 1;
        dataMap.insert(this->headerData(i, Qt::Horizontal).toString(), this->data(ind, role));
    }

    return dataMap;
}
