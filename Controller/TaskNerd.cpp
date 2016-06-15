#include "Controller/TaskNerd.h"

TaskNerd::TaskNerd(QQuickView *window, QObject *parent) : QObject(parent)
{
    window->setGeometry(350, 100, 440, 250);
    window->setMinimumSize(QSize(440, 250));
    window->setResizeMode(QQuickView::SizeRootObjectToView);

    window->installEventFilter(this);

    QQmlContext *context = window->rootContext();

    //TODO: set up a class to populate the model data from a source file (should work with models interchangeably)

    //set one off tasks model for qml window
    qmlRegisterType<TaskModel>("org.qtproject.models", 1, 0, "OneOffTask");
    taskModel = new Models::ListModel(new TaskModel(this));
    this->setTaskModel(taskModel);
    context->setContextProperty("taskModel", taskModel);

    //set weekly tasks model for qml window
    qmlRegisterType<RepeatingTaskModel>("org.qtproject.models", 1, 0, "WeeklyTask");
    weeklyTaskModel = new Models::ListModel(new RepeatingTaskModel(this));
    this->setWeeklyTaskModel(weeklyTaskModel);
    context->setContextProperty("weeklyTaskModel", weeklyTaskModel);

    //set and show the qml window
    window->setSource(QUrl("Resources/QML/TaskNerd.qml"));
    window->show();

    //TODO: set the selected tab radio button at the start of the application
    //QObject *object = window->rootObject();

    //connect(object, SIGNAL(taskCheckedChanged(QString,int,bool)), this, SLOT(slot_receiveData(QString,int,bool)));
}

bool TaskNerd::eventFilter(QObject *obj, QEvent *event)
{
    if(event->type() == QEvent::KeyPress)
    {
        QKeyEvent *keyEvent = (QKeyEvent *)event;

        if(keyEvent->key() == Qt::Key_S && keyEvent->modifiers().testFlag(Qt::ControlModifier))
        {
            //save model here!
            qDebug() << "save model:";

            new SaveModelDataHandler(taskModel);

            qDebug() << "save weekly model";
            new SaveModelDataHandler(weeklyTaskModel);
        }
    }

    return QObject::eventFilter(obj, event);
}

void TaskNerd::setTaskModel(Models::ListModel *model)
{
    for(int i = 0; i < 30; ++i)
    {
        model->appendRow(new TaskModel(i, true, "test"));
    }
}

void TaskNerd::setWeeklyTaskModel(Models::ListModel *model)
{
    for(int i = 0; i < 10; ++i)
    {
        model->appendRow(new RepeatingTaskModel(i, false, "repeating task", "weekly", 4, 3, 5, QVariant()));
    }
}

/*void TaskNerd::slot_receiveData(QString tabName, int index, bool taskIsChecked)
{
    qDebug() << "receiving data:" << tabName << index << taskIsChecked;
    model->setData(model->, taskIsChecked, NerdTaskModel::IsCheckedRole);
}*/
