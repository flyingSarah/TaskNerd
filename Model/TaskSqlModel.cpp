#include "TaskSqlModel.h"

//used stackoverflow for some guidance with this class http://stackoverflow.com/questions/14613824/qsqltablemodel-inheritor-and-qtableview
TaskSqlModel::TaskSqlModel(QObject *parent) : QSqlTableModel(parent)
{
    this->setEditStrategy(QSqlTableModel::OnManualSubmit);
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

bool TaskSqlModel::setRecord(int row, QString roleName, QVariant value)
{
    qDebug() << row << roleName << value;

    QSqlRecord newRecord = this->record(row);
    newRecord.setValue(roleName, value);

    QSqlTableModel::setRecord(row, newRecord);
}

bool TaskSqlModel::insertNewRecord()
{
    QSqlRecord newRecord = this->record(this->count-1);
    newRecord.setValue("isChecked", false);
    newRecord.setValue("label", "");

    QSqlTableModel::insertRecord(this->count, newRecord);
}

QVariant TaskSqlModel::data(const QModelIndex &index, int role) const
{
    if(role < Qt::UserRole)
    {
        return QSqlQueryModel::data(index, role);
    }

    int colIndex = role - Qt::UserRole - 1;
    QModelIndex modelIndex = this->index(index.row(), colIndex);
    return QSqlTableModel::data(modelIndex, Qt::DisplayRole);
}
