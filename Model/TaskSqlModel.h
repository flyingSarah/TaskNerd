#ifndef TASKSQLMODEL_H
#define TASKSQLMODEL_H

#include <QSqlTableModel>
#include <QSqlError>
#include <QSqlQuery>
#include <QDebug>

class TaskSqlModel : public QSqlTableModel
{
    Q_OBJECT
    Q_PROPERTY(int count READ rowCount() NOTIFY countChanged())

public:
    TaskSqlModel(QObject *parent = 0) : QSqlTableModel(parent) {}

    Q_INVOKABLE QVariant data(const QModelIndex &index, int role) const;
    Q_INVOKABLE bool setData(const QModelIndex &index, const QVariant &value, int role);

    void applyRoles();

    virtual QHash<int, QByteArray> roleNames() const { return roles; }

signals:
    void countChanged();

private:
    int count;
    QHash<int, QByteArray> roles;
};

#endif // TASKSQLMODEL_H
