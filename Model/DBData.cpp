#include "DBData.h"

DBData::DBData(QObject *parent) :
    QObject(parent)
{
}

QVariantMap DBData::repeatDefaults()
{
    //TODO:: add repeat-specific parameters
    QVariantMap defaultMap;
    defaultMap.insert("isChecked", 0);
    defaultMap.insert("label", "");
    defaultMap.insert("priority", 2);
    defaultMap.insert("difficulty", 1);
    defaultMap.insert("repeat", 1);
    return defaultMap;
}

QVariantMap DBData::nonRepeatDefaults()
{
    QVariantMap defaultMap;
    defaultMap.insert("isChecked", 0);
    defaultMap.insert("label", "");
    defaultMap.insert("priority", 2);
    defaultMap.insert("difficulty", 1);
    defaultMap.insert("dueDate", QDate());
    return defaultMap;
}

QVariantMap DBData::checklistDefaults()
{
    QVariantMap defaultMap = nonRepeatDefaults();

    return defaultMap;
}

QString DBData::repeatCreateDBString = "isChecked INTEGER, label VARCHAR, priority INTEGER, difficulty INTEGER, repeat INTEGER";
QString DBData::nonRepeatCreateDBString = "isChecked INTEGER, label VARCHAR, priority INTEGER, difficulty INTEGER, dueDate DATE";
QString DBData::checklistCreateDBString = DBData::nonRepeatCreateDBString;

int DBData::countTables()
{
    return 5;
}

QVariantList DBData::dbNames() {
    return QVariantList() << "dailyTasks"           << "weeklyTasks"        << "monthlyTasks"       << "regularTasks"           << "checklistTasks";
}
QVariantList DBData::titles() {
    return QVariantList() << "Daily"                << "Weekly"             << "Monthly"            << "One Off"                << "Checklists";
}
QVariantList DBData::paramDefaultMaps() {
    return QVariantList() << repeatDefaults()       << repeatDefaults()     << repeatDefaults()     << nonRepeatDefaults()      << checklistDefaults();
}
QVariantList DBData::createDbStr =
           QVariantList() << repeatCreateDBString   << repeatCreateDBString << repeatCreateDBString << nonRepeatCreateDBString  << checklistCreateDBString;
