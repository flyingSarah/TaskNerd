#ifndef TASKNERD_H
#define TASKNERD_H

#include <QObject>
#include <QQuickView>
#include <QQmlEngine>
#include <QQmlContext>
#include <QtQuick/qquickitem.h>

#include "Model/TaskSqlModel.h"
#include "Model/DBData.h"

class TaskNerd : public QObject
{
    Q_OBJECT

public:
    TaskNerd(QQuickView *window, QObject *parent = 0);

private:
    QSqlError initDb();
    QSqlError initTables(const QStringList &tables, const QVariantList &tableNames, const QVariantList &createStrings, const QVariantList &defaultMaps);

    bool findNewColumnData(const QString tableName, QStringList &keepColumns, QVariantMap &addColumnsDefaultMap);
    QSqlError deleteOldColumns(QSqlQuery &query, const QString tableName, const QStringList keepColumns);
    QSqlError addNewColumns(QSqlQuery &query, const QString tableName, const QVariantMap defaultMap);

private slots:

};

#endif // TASKNERD_H
