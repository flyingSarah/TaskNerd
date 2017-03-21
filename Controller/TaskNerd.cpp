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
    }

    return err;
}

QSqlError TaskNerd::initTables(const QStringList &tables, const QVariantList &tableNames,
                               const QVariantList &createStrings, const QVariantList &defaultMaps)
{
    QSqlQuery query;

    for(int i = 0; i < tableNames.count(); i++)
    {
        //if the table exists, check the columns to make sure the database contains the most up to date parameters
        //... this is so that features can be added and subtracted without having to respawn the database file
        if(tables.contains(tableNames.at(i).toString()))
        {
            QVariantMap addColumnsDefaultMap = defaultMaps.at(i).toMap();
            QStringList keepColumns;
            bool invalidColumnsExist = findNewColumnData(tableNames.at(i).toString(), keepColumns, addColumnsDefaultMap);

            //delete columns from the database that are no longer valid
            if(invalidColumnsExist)
            {
                QSqlError err = deleteOldColumns(query, tableNames.at(i).toString(), keepColumns);
                if(err.type() != QSqlError::NoError)
                {
                    return err;
                }
            }

            //add columns with their default values if they aren't present in the database
            if(!addColumnsDefaultMap.isEmpty())
            {
                QSqlError err = addNewColumns(query, tableNames.at(i).toString(), addColumnsDefaultMap);
                if(err.type() != QSqlError::NoError)
                {
                    return err;
                }
            }
        }
        //if the table doesn't exist, create it
        else
        {
            QString createTableString = QString("CREATE TABLE %1" "(id INTEGER PRIMARY KEY AUTOINCREMENT, %2)")
                    .arg(tableNames.at(i).toString())
                    .arg(createStrings.at(i).toString());

            if(!query.exec(createTableString))
            {
                return query.lastError();
            }
        }
    }
    return QSqlError();
}

// this function returns a boolean that tells whether invalid columns exist in the database, populates the list
// ... of columns to preserve, and updates the default map to only include columns that need to be added
bool TaskNerd::findNewColumnData(const QString tableName, QStringList &keepColumns, QVariantMap &addColumnsDefaultMap)
{
    QSqlTableModel taskModel;
    QStringList dbTableColumns;
    keepColumns.append("id"); // always keep the task id

    taskModel.setTable(tableName);

    for(int i = 0; i < taskModel.columnCount(); i++)
    {
        QString roleName = taskModel.headerData(i, Qt::Horizontal).toString();
        dbTableColumns.append(roleName);
        if(addColumnsDefaultMap.remove(roleName))
        {
            keepColumns.append(roleName);
        }
    }
    return (keepColumns != dbTableColumns);
}

QSqlError TaskNerd::deleteOldColumns(QSqlQuery &query, const QString tableName, const QStringList keepColumns)
{
    qDebug() << "columns will be deleted from" << tableName;
    QString selectColumnStr;

    for(int j = 0; j < keepColumns.count(); j++)
    {
        selectColumnStr.append(QString("%1, ").arg(keepColumns.at(j)));
    }
    selectColumnStr.remove(selectColumnStr.count()-2, 2);

    if(!query.exec(QString("CREATE TABLE %1_backup AS SELECT %2 FROM %1").arg(tableName).arg(selectColumnStr))
            || !query.exec(QString("DROP TABLE %1").arg(tableName))
            || !query.exec(QString("CREATE TABLE %1 AS SELECT * FROM %1_backup").arg(tableName))
            || !query.exec(QString("DROP TABLE %1_backup").arg(tableName)))
    {
        return query.lastError();
    }
    return QSqlError();
}

QSqlError TaskNerd::addNewColumns(QSqlQuery &query, const QString tableName, const QVariantMap defaultMap)
{
    qDebug() << "columns will be added to" << tableName << defaultMap;
    QMapIterator<QString, QVariant> i(defaultMap);
    while(i.hasNext())
    {
        i.next();

        //TODO: right now, this only works with integers.  I'd like it to work with strings, floats, dates, etc.
        //QString valueType = i.value().typeName();

        QString addColumnQuery = QString("ALTER TABLE %1 ADD COLUMN %2 %3 DEFAULT %4").arg(tableName).arg(i.key()).arg("INTEGER").arg(i.value().toInt());

        if(!query.exec(addColumnQuery))
        {
            return query.lastError();
        }
    }
    return QSqlError();
}
