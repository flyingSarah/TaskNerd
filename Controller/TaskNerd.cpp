#include "Controller/TaskNerd.h"

TaskNerd::TaskNerd(QQuickView *window, QObject *parent) : QObject(parent)
{
    QCoreApplication::setOrganizationName("SarahWhitley");
    QCoreApplication::setOrganizationDomain("swhitley.com");
    QCoreApplication::setApplicationName("TaskNerd");
    QSettings settings;
    initAppSettings(settings);

    window->setGeometry(settings.value("app_x").toInt(), settings.value("app_y").toInt(), settings.value("app_w").toInt(), settings.value("app_h").toInt());
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

    window->installEventFilter(this);
}

bool TaskNerd::eventFilter(QObject *obj, QEvent *event)
{
    if(event->type() == QEvent::Resize)
    {
        QResizeEvent *resizeEvent = (QResizeEvent *)event;
        QSettings settings;
        settings.setValue("app_w", resizeEvent->size().width());
        settings.setValue("app_h", resizeEvent->size().height());
    }
    if(event->type() == QEvent::Move)
    {
        QMoveEvent *moveEvent = (QMoveEvent *)event;
        QSettings settings;
        settings.setValue("app_x", moveEvent->pos().x());
        settings.setValue("app_y", moveEvent->pos().y());
    }

    return QObject::eventFilter(obj, event);
}

void TaskNerd::initAppSettings(QSettings &settings)
{
    if(!settings.contains("app_x"))
    {
        settings.setValue("app_x", 350);
    }
    if(!settings.contains("app_y"))
    {
        settings.setValue("app_y", 100);
    }
    if(!settings.contains("app_w"))
    {
        settings.setValue("app_w", 440);
    }
    if(!settings.contains("app_h"))
    {
        settings.setValue("app_h", 250);
    }
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
        QString createTableString = QString("CREATE TABLE %1" "(id INTEGER PRIMARY KEY AUTOINCREMENT, %2)")
                .arg(tableNames.at(i).toString())
                .arg(createStrings.at(i).toString());

        //if the table exists, check the columns to make sure the database contains the most up to date parameters
        //... this is so that features can be added and subtracted without having to respawn the database file
        if(tables.contains(tableNames.at(i).toString()))
        {
            TaskSqlModel taskModel;
            taskModel.setupModel(tableNames.at(i).toString());
            QStringList tableParameters = taskModel.parameterNames();

            QStringList keepColumns = findColumnsToKeep(tableParameters, defaultMaps.at(i).toMap());

            //delete columns from the database that are no longer valid
            if(keepColumns != tableParameters)
            {
                QSqlError err = updateColumns(query, tableNames.at(i).toString(), createTableString, keepColumns);
                if(err.type() != QSqlError::NoError)
                {
                    return err;
                }
            }
        }
        //if the table doesn't exist, create it
        else
        {
            if(!query.exec(createTableString))
            {
                return query.lastError();
            }
        }
    }
    return QSqlError();
}

// this function populates a list of columns to preserve during the column update
QStringList TaskNerd::findColumnsToKeep(const QStringList &tableParameters, const QVariantMap &defaultMap)
{
    QStringList newColumns = defaultMap.keys();
    newColumns.prepend("id"); // id is never listed in default maps
    QSet<QString> intersection = tableParameters.toSet().intersect(newColumns.toSet());
    return intersection.toList();
}

QSqlError TaskNerd::updateColumns(QSqlQuery &query, const QString &tableName, const QString &createString, const QStringList &keepColumns)
{
    QString selectColumnStr;

    for(int j = 0; j < keepColumns.count(); j++)
    {
        selectColumnStr.append(QString("%1, ").arg(keepColumns.at(j)));
    }
    selectColumnStr.remove(selectColumnStr.count()-2, 2);

    if(!query.exec(QString("CREATE TABLE %1_backup AS SELECT %2 FROM %1").arg(tableName).arg(selectColumnStr))
            || !query.exec(QString("DROP TABLE %1").arg(tableName))
            || !query.exec(createString)
            || !query.exec(QString("INSERT INTO %1 (%2) SELECT %2 FROM %1_backup").arg(tableName).arg(selectColumnStr))
            || !query.exec(QString("DROP TABLE %1_backup").arg(tableName)))
    {
        return query.lastError();
    }
    return QSqlError();
}
