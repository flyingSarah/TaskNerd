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
    qmlRegisterType<DBData>("com.swhitley.models", 1, 0, "TaskTabInfo");

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

    QSqlQuery query;

    QStringList tables = taskDb.tables();

    for(int i = 0; i < DBData::countTables(); i++)
    {
        //create or find task table in database
        if(tables.contains(DBData::dbNames().at(i).toString(), Qt::CaseInsensitive))
        {
            //table has already been populated
            return QSqlError();
        }

        QString createTableString = QString("CREATE TABLE %1" "(id INTEGER PRIMARY KEY AUTOINCREMENT, %2)")
                .arg(DBData::dbNames().at(i).toString())
                .arg(DBData::createDbStr.at(i).toString());

        //qDebug() << "initDB:" << createTableString;

        if(!query.exec(createTableString))
        {
            return query.lastError();
        }
    }

    return QSqlError();
}
