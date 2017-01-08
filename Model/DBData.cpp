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

QString repeatCreateDbString = "isChecked INTEGER, label VARCHAR";
QString noRepeatCreateDbString = "isChecked INTEGER, label VARCHAR";

int DBData::countTables()
{
    return 4;
}

QVariantList DBData::dbNames() {
    return QVariantList() << "regularTasks"         << "dailyTasks"         << "weeklyTasks"        << "monthlyTasks";
}
QVariantList DBData::titles() {
    return QVariantList() << "One Off Tasks"        << "Daily Tasks"        << "Weekly Tasks"       << "Monthly Tasks";
}
QVariantList DBData::canRepeat() {
    return QVariantList() << false                  << true                 << true                 << true;
}
QVariantList DBData::paramDefaultMaps() {
    return QVariantList() << nonRepeatDefaults()    << repeatDefaults()     << repeatDefaults()     << repeatDefaults();
}
QVariantList DBData::createDbStr =
           QVariantList() << noRepeatCreateDbString << repeatCreateDbString << repeatCreateDbString << repeatCreateDbString;
