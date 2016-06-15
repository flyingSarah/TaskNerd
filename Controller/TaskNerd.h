#ifndef TASKNERD_H
#define TASKNERD_H

#include <QObject>
#include <QQuickView>
#include <qqmlengine.h>
#include <qqmlcontext.h>
#include <qqml.h>
#include <QtQuick/qquickitem.h>

#include "Model/ListModel.h"
#include "Model/TaskModel.h"
#include "Model/RepeatingTaskModel.h"

class TaskNerd : public QObject
{
    Q_OBJECT

public:
    TaskNerd(QQuickView *window, QObject *parent = 0);

private:
    Models::ListModel *taskModel;
    Models::ListModel *weeklyTaskModel;
    void setTaskModel(Models::ListModel *model);
    void setWeeklyTaskModel(Models::ListModel *model);

private slots:
    //void slot_receiveData(QString tabName,int index, bool taskIsChecked);
};

#endif // TASKNERD_H
