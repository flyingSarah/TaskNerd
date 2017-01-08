#ifndef DBDATA_H
#define DBDATA_H

#include <QObject>
#include <QStringList>
#include <QVariantMap>
#include <QDebug>

class DBData : public QObject
{
    Q_OBJECT
public:
    explicit DBData(QObject *parent = 0);

    //Q_INVOKABLE static QVariantList initTables();

    //static QVariantMap getDefaultMapForTable(int tableIndex);

    Q_INVOKABLE static int countTables();
    Q_INVOKABLE static QVariantList dbNames();
    Q_INVOKABLE static QVariantList titles();
    Q_INVOKABLE static QVariantList canRepeat();
    Q_INVOKABLE static QVariantList paramDefaultMaps();
    static QVariantList createDbStr;

private:

    static QVariantMap repeatDefaults();
    static QVariantMap nonRepeatDefaults();

    static QString nonRepeatingCreateTableDBString;
    static QString repeatingCreateTableDBString;
};

#endif // DBDATA_H
