/****************************************************************************
**
** Copyright (C) 2013 Digia Plc and/or its subsidiary(-ies).
** Contact: http://www.qt-project.org/legal
**
** This file has been modified from the examples of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:BSD$
** You may use this file under the terms of the BSD license as follows:
**
** "Redistribution and use in source and binary forms, with or without
** modification, are permitted provided that the following conditions are
** met:
**   * Redistributions of source code must retain the above copyright
**     notice, this list of conditions and the following disclaimer.
**   * Redistributions in binary form must reproduce the above copyright
**     notice, this list of conditions and the following disclaimer in
**     the documentation and/or other materials provided with the
**     distribution.
**   * Neither the name of Digia Plc and its Subsidiary(-ies) nor the names
**     of its contributors may be used to endorse or promote products derived
**     from this software without specific prior written permission.
**
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
** "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
** LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
** A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
** OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
** SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
** LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
** DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
** THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
** (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
** OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."
**
** $QT_END_LICENSE$
**
****************************************************************************/

#include "Model/TaskModel.h"

TaskModel::TaskModel(QObject *parent) : Models::ListItem(parent)
{
}

TaskModel::TaskModel(const int &id, const bool &isChecked, const QString &label, QObject *parent) :
    Models::ListItem(parent),
    taskId(id),
    isChecked(isChecked),
    label(label)
{
}

int TaskModel::id() const
{
    return this->taskId;
}

QVariant TaskModel::data(int role) const
{
    switch(role)
    {
    case IsCheckedRole:
        return this->isChecked;
    case LabelRole:
        return this->label;
    case IdRole:
        return this->id();
    default:
        QVariant();
    }
}

bool TaskModel::setData(int role, const QVariant &value)
{
    switch(role)
    {
    case IsCheckedRole:
        this->isChecked = value.toBool();
        this->triggerItemUpdate();
        return true;
    case LabelRole:
        this->label = value.toString();
        this->triggerItemUpdate();
        return true;
    default :
        return false;
    }
}

// ASSIGN THE NAME TO USE FROM QML SIDE TO ACCESS VALUES
QHash<int, QByteArray> TaskModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[IsCheckedRole] = "isChecked";
    roles[LabelRole] = "label";
    roles[IdRole] = "id";
    return roles;
}

void TaskModel::setIsChecked(const bool &isChecked)
{
    this->isChecked = isChecked;
}

void TaskModel::setLabel(const QString &label)
{
    this->label = label;
}
