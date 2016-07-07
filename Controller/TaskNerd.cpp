#include "Controller/TaskNerd.h"

TaskNerd::TaskNerd(QQuickView *window, QObject *parent) : QObject(parent)
{
    window->setGeometry(350, 100, 440, 250);
    window->setMinimumSize(QSize(440, 250));
    window->setResizeMode(QQuickView::SizeRootObjectToView);

    window->installEventFilter(this);

    QQmlContext *context = window->rootContext();

    QSqlError err = initDb();
    if(err.type() != QSqlError::NoError)
    {
        qCritical() << err.text();
        qDebug() << "error initializing database";
    }
    else
    {
        taskModel = new TaskSqlModel();
        taskModel->setEditStrategy(QSqlTableModel::OnManualSubmit);
        taskModel->setTable("tasks");
        taskModel->applyRoles();
        taskModel->select();
        context->setContextProperty("taskModel", taskModel);
    }

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
            //TODO: save the sql database here -- but make it so it only saves when you want it to
            qDebug() << "save model:";
        }
    }

    return QObject::eventFilter(obj, event);
}

QSqlError TaskNerd::initDb()
{
    QSqlDatabase taskDb = QSqlDatabase::addDatabase("QSQLITE");
    taskDb.setDatabaseName("Resources/TaskDatabase.sqlite");

    if(!taskDb.open())
    {
        qDebug() << "Database: connection error";
        return taskDb.lastError();
    }

    QStringList tables = taskDb.tables();
    if(tables.contains("tasks", Qt::CaseInsensitive))
    {
        //database has already been populated
        return QSqlError();
    }

    QSqlQuery query;
    if(!query.exec("CREATE TABLE tasks" "(id INTEGER PRIMARY KEY AUTOINCREMENT, isChecked INTEGER, label VARCHAR)"))
    {
        return query.lastError();
    }

    for(int i = 0; i < 30; i++)
    {
        if(!query.exec(QString("INSERT INTO tasks (id, isChecked, label)" "VALUES (%1, 0, 'Test Label %1')").arg(i)))
        {
            return query.lastError();
        }
    }

    return QSqlError();
}
