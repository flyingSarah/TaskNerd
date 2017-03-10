#ifndef DBDATA_H
#define DBDATA_H

#include <QObject>
#include <QStringList>
#include <QVariantMap>
#include <QDebug>
#include <QDate>

class DBData : public QObject
{
    Q_OBJECT
public:
    explicit DBData(QObject *parent = 0);

    //Task tables
    Q_INVOKABLE static QVariantList taskTableNames();
    Q_INVOKABLE static QVariantList taskTableTitles();
    Q_INVOKABLE static QVariantList taskDefaultMaps();
    static QVariantList taskCreateStrings;

    //Parameter tables
    Q_INVOKABLE static QVariantList parameterTableNames();
    Q_INVOKABLE static QVariantList parameterDefaultMaps();
    static QVariantList parameterCreateStrings;

    //Map tables
    //Q_INVOKABLE static QVariantList mapTableNames();
    //static QVariantList mapCreateStrings;


private:

    //Task tables
    static QVariantMap baseTaskDefaults();  //parameters all task tables have
    static QVariantMap repeatTaskDefaults();
    static QVariantMap nonRepeatTaskDefaults();
    static QVariantMap checklistTaskDefaults();

    static QString baseTaskCreateString;
    static QString repeatTaskCreateString;
    static QString nonRepeatTaskCreateString;
    static QString checklistTaskCreateString;

    //Parameter tables
    static QVariantMap checklistParamDefaults();

    static QString checklistParamCreateString;

    //Map tables
    //static QString checklistMapCreateString;
};

#endif // DBDATA_H
