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

    QSqlError err;

    QStringList tables = taskDb.tables();

    //find task, parameter, and map tables in database - if one isn't there create it
    err = initTables(tables, DBData::taskTableNames(), DBData::taskCreateStrings, DBData::taskDefaultMaps());
    if(err.type() == QSqlError::NoError)
    {
        err = initTables(tables, DBData::parameterTableNames(), DBData::parameterCreateStrings, DBData::parameterDefaultMaps());
        /*if(err.type() == QSqlError::NoError)
        {
            err = initTables(tables, DBData::mapTableNames(), DBData::mapCreateStrings, QVariantList());
        }*/
    }

    return err;
}

QSqlError TaskNerd::initTables(const QStringList &tables, const QVariantList &tableNames,
                               const QVariantList &createStrings, const QVariantList &defaultMaps)
{
    QSqlQuery query;

    for(int i = 0; i < tableNames.count(); i++)
    {
        if(tables.contains(tableNames.at(i).toString()))
        {
            //TODO: check existing table data for missing columns based on the default maps
        }
        else
        {
            QString createTableString = QString("CREATE TABLE %1" "(id INTEGER PRIMARY KEY AUTOINCREMENT, %2)")
                    .arg(tableNames.at(i).toString())
                    .arg(createStrings.at(i).toString());

            qDebug() << "initTable:" << createTableString;

            if(!query.exec(createTableString))
            {
                return query.lastError();
            }
        }
    }
    return QSqlError();
}
