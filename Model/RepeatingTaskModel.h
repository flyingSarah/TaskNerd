#ifndef REPEATINGTASKMODEL_H
#define REPEATINGTASKMODEL_H

#include "Model/TaskModel.h"

class RepeatingTaskModel : public TaskModel
{
    Q_OBJECT

    Q_PROPERTY(QString type WRITE setType)
    Q_PROPERTY(int repeatCount WRITE setRepeatCount)
    Q_PROPERTY(int repeatsChecked WRITE setRepeatsChecked)
    Q_PROPERTY(int streakCount WRITE setStreakCount)
    Q_PROPERTY(QVariant history WRITE setHistory)

public:
    explicit RepeatingTaskModel(QObject *parent = NULL);
    explicit RepeatingTaskModel(const int &id, const bool &isChecked, const QString &label, const QString &type,
                                const int &repeatCount, const int &repeatsChecked, const int &streakCount,
                                const QVariant &history, QObject *parent = NULL);

    enum RepeatingTaskEnum
    {
        TypeRole = IdRole +1,
        RepeatCountRole,
        RepeatsCheckedRole,
        StreakCountRole,
        HistoryRole
    };

    virtual QVariant data(int role) const;
    virtual bool setData(int role, const QVariant &value);
    virtual QHash<int, QByteArray> roleNames() const;

    void setType(const QString &type);
    void setRepeatCount(const int &repeatCount);
    void setRepeatsChecked(const int &repeatsChecked);
    void setStreakCount(const int &streakCount);
    void setHistory(const QVariant &history);

private:
    QString type;
    int repeatCount;
    int repeatsChecked;
    int streakCount;
    QVariant history;
};

#endif // REPEATINGTASKMODEL_H
