#ifndef TASKNERD_H
#define TASKNERD_H

#include <QObject>
#include <QQuickView>
#include <QQmlEngine>
#include <QQmlContext>
#include <QtQuick/qquickitem.h>
#include <QSettings>

#include "Model/TaskSqlModel.h"
#include "Model/DBData.h"

class TaskNerd : public QObject
{
    Q_OBJECT

public:
    TaskNerd(QQuickView *window, QObject *parent = 0);

protected:
    bool eventFilter(QObject *, QEvent *);

private:
    QSqlError initDb();
    QSqlError initTables(const QStringList &tables, const QVariantList &tableNames, const QVariantList &createStrings, const QVariantList &defaultMaps);

    QStringList findColumnsToKeep(const QStringList &tableParameters, const QVariantMap &defaultMap);
    QSqlError updateColumns(QSqlQuery &query, const QString &tableName, const QString &createString, const QStringList &keepColumns);

    void initAppSettings(QSettings &settings);

private slots:

};

#endif // TASKNERD_H
