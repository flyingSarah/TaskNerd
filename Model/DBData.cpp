#include "DBData.h"

DBData::DBData(QObject *parent) :
    QObject(parent)
{
}

QVariantMap DBData::repeatDefaults()
{
    //TODO:: add repeat-specific parameters
    QVariantMap defaultMap;
    defaultMap.insert("isChecked", QVariant(0));
    defaultMap.insert("label", "");
    return defaultMap;
}

QVariantMap DBData::nonRepeatDefaults()
{
    QVariantMap defaultMap;
    defaultMap.insert("isChecked", QVariant(0));
    defaultMap.insert("label", "");
    return defaultMap;
}

QVariantMap DBData::checklistDefaults()
{
    QVariantMap defaultMap;
    defaultMap.insert("isChecked", QVariant(0));
    defaultMap.insert("label", "");
    defaultMap.insert("date", QDate());
    return defaultMap;
}

QString DBData::repeatCreateDBString = "isChecked INTEGER, label VARCHAR";
QString DBData::nonRepeatCreateDBString = "isChecked INTEGER, label VARCHAR";
QString DBData::checklistCreateDBString = "isChecked INTEGER, label VARCHAR, date DATE";

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
