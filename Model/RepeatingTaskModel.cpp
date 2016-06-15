#include "RepeatingTaskModel.h"

RepeatingTaskModel::RepeatingTaskModel(QObject *parent) : TaskModel(parent)
{
}

RepeatingTaskModel::RepeatingTaskModel(const int &id, const bool &isChecked, const QString &label, const QString &type,
                                       const int &repeatCount, const int &repeatsChecked, const int &streakCount,
                                       const QVariant &history, QObject *parent) :
    TaskModel(id, isChecked, label, parent),
    type(type),
    repeatCount(repeatCount),
    repeatsChecked(repeatsChecked),
    streakCount(streakCount),
    history(history)
{
}

QVariant RepeatingTaskModel::data(int role) const
{
    switch(role)
    {
    case TypeRole:
        return this->type;
    case RepeatCountRole:
        return this->repeatCount;
    case RepeatsCheckedRole:
        return this->repeatsChecked;
    case StreakCountRole:
        return this->streakCount;
    case HistoryRole:
        return this->history;
    default:
        return TaskModel::data(role);
    }
}

bool RepeatingTaskModel::setData(int role, const QVariant &value)
{
    switch(role)
    {
    case TypeRole:
        this->type = value.toString();
        break;
    case RepeatCountRole:
        this->repeatCount = value.toInt();
        break;
    case RepeatsCheckedRole:
        this->repeatsChecked = value.toInt();
        break;
    case StreakCountRole:
        this->streakCount = value.toInt();
        break;
    case HistoryRole:
        this->history = value;
        break;
    default:
        TaskModel::setData(role,value);
    }

    this->triggerItemUpdate();
    return true;
}

QHash<int, QByteArray> RepeatingTaskModel::roleNames() const
{
    QHash<int, QByteArray> roles;

    //TODO: do this next: assign the TaskModel role names to this QHash without manually adding them here (currently this breaks OCP)

    roles[IsCheckedRole] = "isChecked";
    roles[LabelRole] = "label";
    roles[IdRole] = "id";
    roles[TypeRole] = "type";
    roles[RepeatCountRole] = "repeatCount";
    roles[RepeatsCheckedRole] = "repeatsChecked";
    roles[StreakCountRole] = "streakCount";
    roles[HistoryRole] = "history";
    return roles;
}

void RepeatingTaskModel::setType(const QString &type)
{
    this->type = type;
}

void RepeatingTaskModel::setRepeatCount(const int &repeatCount)
{
    this->repeatCount = repeatCount;
}

void RepeatingTaskModel::setRepeatsChecked(const int &repeatsChecked)
{
    this->repeatsChecked = repeatsChecked;
}

void RepeatingTaskModel::setStreakCount(const int &streakCount)
{
    this->streakCount = streakCount;
}

void RepeatingTaskModel::setHistory(const QVariant &history)
{
    this->history = history;
}
