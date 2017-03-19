#ifndef TASKSQLMODEL_H
#define TASKSQLMODEL_H

#include <QSqlRelationalTableModel>
#include <QSqlError>
#include <QSqlQuery>
#include <QSqlRecord>
#include <QDebug>
#include <QKeyEvent>

class TaskSqlModel : public QSqlRelationalTableModel
{
    Q_OBJECT
    Q_PROPERTY(int count READ rowCount() NOTIFY countChanged())

public:
    TaskSqlModel(QObject *parent = 0);

    Q_INVOKABLE bool setupModel(const QString &table, QString relatedTableName = QString(), QString replaceColumn = QString(), QString displayColumn = QString());
    Q_INVOKABLE QVariant data(const QModelIndex &index, int role) const;
    Q_INVOKABLE bool insertNewRecord(QVariantMap defaultTaskMap);
    Q_INVOKABLE bool setDataValue(int row, QString roleName, const QVariant &value);
    Q_INVOKABLE bool removeRows(int row, int count, const QModelIndex &parent = QModelIndex());

    Q_INVOKABLE QVariantList relatedData(int index, QString relatedTableColumn) const;
    Q_INVOKABLE bool insertNewRelatedRecord(int index, QString relatedTableColumn, QVariantMap defaultTaskMap, QString relatedTaskIdKey = "taskId");
    Q_INVOKABLE bool setRelatedDataValue(int index, QString relatedTableColumn, int row, QString roleName, const QVariant &value);
    Q_INVOKABLE bool removeRelatedRows(int index, QString relatedTableColumn, int row, int count, const QModelIndex &parent = QModelIndex());

    Q_INVOKABLE QVariantList parameterNames();

    void applyRoles();

    virtual QHash<int, QByteArray> roleNames() const { return roles; }

signals:
    void countChanged();

private:
    int count;
    QHash<int, QByteArray> roles;

    QSqlRecord recordFromMap(QVariantMap dataMap, QSqlRecord record);
};

#endif // TASKSQLMODEL_H
