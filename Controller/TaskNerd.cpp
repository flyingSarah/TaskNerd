#include "Controller/TaskNerd.h"

TaskNerd::TaskNerd(QQuickView *window, QObject *parent) : QObject(parent)
{
    window->setGeometry(350, 100, 440, 250);
    window->setMinimumSize(QSize(440, 250));
    window->setResizeMode(QQuickView::SizeRootObjectToView);

    QQmlContext *context = window->rootContext();

    qmlRegisterType<TaskModel>("org.qtproject.models", 1, 0, "Task");
    Models::ListModel *taskModel = new Models::ListModel(new TaskModel());
    this->setModel(taskModel);

    context->setContextProperty("taskModel", taskModel);
    window->setSource(QUrl("Resources/QML/TaskNerd.qml"));

    window->show();

    //QObject *object = window->rootObject();

    //connect(object, SIGNAL(taskCheckedChanged(QString,int,bool)), this, SLOT(slot_receiveData(QString,int,bool)));
}

void TaskNerd::setModel(Models::ListModel *model)
{
    for(int i = 0; i < 30; ++i)
    {
        model->appendRow(new TaskModel(0, true, "test"));
    }
}

/*void TaskNerd::slot_receiveData(QString tabName, int index, bool taskIsChecked)
{
    qDebug() << "receiving data:" << tabName << index << taskIsChecked;
    model->setData(model->, taskIsChecked, NerdTaskModel::IsCheckedRole);
}*/
