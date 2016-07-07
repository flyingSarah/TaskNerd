#ifndef TASKNERD_H
#define TASKNERD_H

#include <QObject>
#include <QQuickView>
#include <QQmlEngine>
#include <QQmlContext>
#include <QtQuick/qquickitem.h>

#include "Model/TaskSqlModel.h"

class TaskNerd : public QObject
{
    Q_OBJECT

public:
    TaskNerd(QQuickView *window, QObject *parent = 0);

protected:
    bool eventFilter(QObject *, QEvent *);

private:
    TaskSqlModel *taskModel;

    QSqlError initDb();

private slots:
    //void slot_receiveData(QString tabName,int index, bool taskIsChecked);
};

#endif // TASKNERD_H
