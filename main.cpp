#include <QApplication>
#include <QtQml>
#include <QQuickView>
#include <QQuickItem>
#include <QDebug>

#include "gamemanager.h"

int main(int argc, char **argv)
{
    QApplication app(argc, argv);

    QQmlApplicationEngine engine;
    QQmlContext *context = engine.rootContext();
    GameManager *gameManager = new GameManager(context);

    context->setContextProperty("gameManager", gameManager);

    engine.load(QUrl::fromLocalFile("StartWizard.qml"));
    QObject *topLevel = engine.rootObjects().value(0);

    QQuickWindow *window = qobject_cast<QQuickWindow *>(topLevel);
    window->show();

    return app.exec();
}   

