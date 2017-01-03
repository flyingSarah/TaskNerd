#include "Controller/TaskNerd.h"

TaskNerd::TaskNerd(QQuickView *window, QObject *parent) : QObject(parent)
{
    window->setGeometry(350, 100, 440, 250);
    window->setMinimumSize(QSize(440, 250));
    window->setResizeMode(QQuickView::SizeRootObjectToView);

    QSqlError err = initDb();
    if(err.type() != QSqlError::NoError)
    {
        qCritical() << err.text();
        qDebug() << "error initializing database";
    }

    qmlRegisterType<TaskSqlModel>("com.swhitley.models", 1, 0, "TaskModel");

    //set and show the qml window
    window->setSource(QUrl("Resources/QML/TaskNerd.qml"));
    window->show();

    //QObject *object = window->rootObject();
    //connect(object, SIGNAL(taskCheckedChanged(QString,int,bool)), this, SLOT(slot_receiveData(QString,int,bool)));
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
    //create or find regular tasks:
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
        if(!query.exec(QString("INSERT INTO tasks (isChecked, label)" "VALUES (0, 'Test Label %1')").arg(i)))
        {
            return query.lastError();
        }
    }

    //create or find weekly tasks
    if(tables.contains("weeklyTasks", Qt::CaseInsensitive))
    {
        //database has already been populated
        return QSqlError();
    }

    if(!query.exec("CREATE TABLE weeklyTasks" "(id INTEGER PRIMARY KEY AUTOINCREMENT, isChecked INTEGER, label VARCHAR)"))
    {
        return query.lastError();
    }

    for(int i = 0; i < 30; i++)
    {
        if(!query.exec(QString("INSERT INTO weeklyTasks (isChecked, label)" "VALUES (0, 'Weekly Test Label %1')").arg(i)))
        {
            return query.lastError();
        }
    }

    return QSqlError();
}
