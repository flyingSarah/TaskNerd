#include "TaskSqlModel.h"

//used stackoverflow for some guidance with this class http://stackoverflow.com/questions/14613824/qsqltablemodel-inheritor-and-qtableview

void TaskSqlModel::applyRoles()
{
    roles.clear();

    for(int i = 0; i < this->columnCount(); i++)
    {
        QString role = this->headerData(i, Qt::Horizontal).toString();
        roles[Qt::UserRole + i + 1] = QVariant(role).toByteArray();
    }
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

bool TaskSqlModel::setData(const QModelIndex &index, const QVariant &value, int role)
{
    if(index.row() >= 0 && index.row() < this->rowCount() && index.column() >= 0 && index.column() < this->columnCount())
    {
        QString valAsString;

        if(value.canConvert<bool>())
        {
            valAsString = QString("%1").arg(value.toInt());
            //qDebug() << "value can convert to bool" << valAsString;
        }
        else
        {
            valAsString = value.toString();
        }

        int rowId = index.row();

        bool returnVal = this->query().exec(QString("UPDATE %1 SET isChecked = %2 WHERE id = %3").arg(this->tableName()).arg(valAsString).arg(rowId));

        qDebug() << "UPDATE" << this->tableName() << "SET ?? =" << valAsString << "WHERE id =" << rowId << "| executed:" << returnVal;
        this->select();
        return returnVal;
    }

    return false;
}
