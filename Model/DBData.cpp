#include "DBData.h"

DBData::DBData(QObject *parent) :
    QObject(parent)
{
}

// ----------------------------------------------------------------- Create Database Strings

QString DBData::baseTaskCreateString = "label VARCHAR DEFAULT '', priority INTEGER DEFAULT 2, difficulty INTEGER DEFAULT 1";
QString DBData::repeatTaskCreateString = "isChecked INTEGER DEFAULT 0, " + DBData::baseTaskCreateString + ", repeat INTEGER DEFAULT 1";
QString DBData::nonRepeatTaskCreateString = "isChecked INTEGER DEFAULT 0, " + DBData::baseTaskCreateString + ", dueDate DATE DEFAULT null";
QString DBData::checklistTaskCreateString = DBData::baseTaskCreateString + ", dueDate INTEGER DEFAULT null, checklistCount INTEGER DEFAULT 0";

QString DBData::checklistParamCreateString = "taskId INTEGER, isChecked INTEGER DEFAULT 0, label VARCHAR DEFAULT '', count INTEGER DEFAULT 0";
//QString DBData::checklistMapCreateString = "taskID INTEGER";


// ----------------------------------------------------------------- Public Data


// ----------------------------------------------- Task Tables
QVariantList DBData::taskTableNames()
{
    return QVariantList() << "dailyTasks"           << "weeklyTasks"            << "monthlyTasks"           << "regularTasks"               << "checklistTasks";
}
QVariantList DBData::taskTableTitles()
{
    return QVariantList() << "Daily"                << "Weekly"                 << "Monthly"                << "One Off"                    << "Checklists";
}
QVariantList DBData::taskDefaultMaps()
{
    return QVariantList() << repeatTaskDefaults()   << repeatTaskDefaults()     << repeatTaskDefaults()     << nonRepeatTaskDefaults()      << checklistTaskDefaults();
}
QVariantList DBData::taskCreateStrings =
           QVariantList() << repeatTaskCreateString << repeatTaskCreateString   << repeatTaskCreateString   << nonRepeatTaskCreateString    << checklistTaskCreateString;

// ----------------------------------------------- Parameter Tables
QVariantList DBData::parameterTableNames()
{
    return QVariantList() << "checklistChecklistParams";
}
QVariantList DBData::parameterDefaultMaps()
{
    return QVariantList() << checklistParamDefaults();
}
QVariantList DBData::parameterCreateStrings = QVariantList() << checklistParamCreateString;

// ----------------------------------------------- Map Tables
/*QVariantList DBData::mapTableNames()
{
    return QVariantList() << "checklistChecklistMap";
}
QVariantList DBData::mapCreateStrings = QVariantList() << checklistMapCreateString;
*/

// ----------------------------------------------------------------- Defaults


// ----------------------------------------------- Task Tables
QVariantMap DBData::baseTaskDefaults()
{
    QVariantMap defaultMap;
    defaultMap.insert("label", "");
    defaultMap.insert("priority", 2);
    defaultMap.insert("difficulty", 1);
    return defaultMap;
}

QVariantMap DBData::repeatTaskDefaults()
{
    QVariantMap defaultMap = baseTaskDefaults();
    defaultMap.insert("isChecked", 0);
    defaultMap.insert("repeat", 1);
    return defaultMap;
}

QVariantMap DBData::nonRepeatTaskDefaults()
{
    QVariantMap defaultMap = baseTaskDefaults();
    defaultMap.insert("isChecked", 0);
    defaultMap.insert("dueDate", QDate());
    return defaultMap;
}

QVariantMap DBData::checklistTaskDefaults()
{
    QVariantMap defaultMap = baseTaskDefaults();
    defaultMap.insert("dueDate", QDate());
    defaultMap.insert("checklistCount", 0);

    return defaultMap;
}

// ----------------------------------------------- Parameter Tables
QVariantMap DBData::checklistParamDefaults()
{
    QVariantMap defaultMap;
    defaultMap.insert("isChecked", 0);
    defaultMap.insert("label", "");
    defaultMap.insert("count", 0);

    return defaultMap;
}
