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


private slots:

};

#endif // TASKNERD_H
