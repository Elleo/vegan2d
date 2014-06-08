#include <QQuickItem>
#include <QDebug>
#include <QMetaProperty>
#include <QVariant>
#include <QRegExp>
#include <QFile>
#include <QTextStream>

#include "qmlwriter.h"

void QmlWriter::save(QQuickItem *game, QString filename)
{
    qDebug() << "Saving " << game << " to " << filename;
    QString qmlOutput = "import QtQuick 2.2\nimport Bacon2D 1.0\n\n";
    qmlOutput += dumpRecursive(game, "");
    qDebug() << qmlOutput;
    QFile file(filename);
    if (!file.open(QIODevice::WriteOnly | QIODevice::Text))
        return;

    QTextStream out(&file);
    out << qmlOutput;
}

QString QmlWriter::dumpRecursive(QObject *item, QString tab)
{
    qDebug() << "Dumping " << item;
    QString className = item->metaObject()->className();
    if(className == "StepDriver" || className == "Box2DProfile") {
        return "";
    }
    bool skipChildren = false;
    if(className.contains("_QML") && !className.contains("Box2DWorld")) {
        skipChildren = true;
    }
    // TODO: Find proper way of getting QML name
    className = className.replace("Box2D", "");
    className = className.replace("QQuick", "");
    className = className.replace(QRegExp("_QML.*"), "");
    QString qml = tab + className + " {\n";
    tab += "    ";
    // HACK: set current scene
    if(className == "Game") {
        qml += tab + "currentScene: scene\n";
    }
    if(className == "Scene") {
        qml += tab + "id: scene\n";
    }
    if(className == "World") {
        qml += tab + "id: world\n";
    }
    for(int i = 0; i < item->metaObject()->propertyCount(); i++) {
        QMetaProperty prop = item->metaObject()->property(i);
        // TODO: Figure out how to automatically tell which properties can be included
        // TODO: Convert enums
        if(prop.isWritable() 
                && prop.name() != QString("transformOrigin") 
                && prop.name() != QString("activeFocusOnTab")
                && prop.name() != QString("renderTarget")
                && prop.name() != QString("bodyType")
                && prop.name() != QString("flags")
                && prop.name() != QString("implicitHeight")
                && prop.name() != QString("implicitWidth")
                && prop.name() != QString("verticalAlignment")
                && prop.name() != QString("horizontalAlignment")
                && prop.name() != QString("fillMode")) {
            QVariant propVar = prop.read(item);
            if(propVar.canConvert(QVariant::String) && !propVar.toString().isEmpty()) {
                qml += tab + QString(prop.name()) + ": ";
                if(className == "World" && prop.name() == QString("running")) {
                    // HACK: Override running state set by editor
                    qml += "true\n";
                } else {
                    if(propVar.type() == QVariant::String || propVar.type() == QVariant::Url || propVar.type() == QVariant::Color) {
                        qml += "\"" + propVar.toString() + "\"\n";
                    } else {
                        qml += propVar.toString() + "\n";
                    }
                }
            }
        }
    }

    if(!skipChildren) {
        foreach(QObject *child, item->children()) {
            qml += "\n" + dumpRecursive(child, tab);
        }
    }

    tab.chop(5);
    qml += tab + " }\n";
    return qml;
}
