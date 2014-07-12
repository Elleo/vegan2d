var itemComponent = null;
var draggedItem = null;
var startingMouse;
var posnInWindow;

function startDrag(mouse)
{
    posnInWindow = paletteItem.mapToItem(scene, 0, 0);
    startingMouse = { x: mouse.x, y: mouse.y }
    loadComponent();
}

//Creation is split into two functions due to an asynchronous wait while
//possible external files are loaded.

function loadComponent() {
    if (itemComponent != null) { // component has been previously loaded
        createItem();
        return;
    }

    itemComponent = Qt.createComponent(paletteItem.componentFile);
    if (itemComponent.status == Component.Loading)  //Depending on the content, it can be ready or error immediately
        component.statusChanged.connect(createItem);
    else
        createItem();
}

function createItem() {
    if (itemComponent.status == Component.Ready && draggedItem == null) {
        draggedItem = itemComponent.createObject(scene, {"image": paletteItem.image.replace("mygame/", ""), "x": posnInWindow.x, "y": posnInWindow.y, "z": 3});
        selectionComponent.createObject(draggedItem);
    } else if (itemComponent.status == Component.Error) {
        draggedItem = null;
        console.log("error creating component");
        console.log(itemComponent.errorString());
    }
}

function continueDrag(mouse)
{
    if (draggedItem == null)
        return;

    draggedItem.x = mouse.x + posnInWindow.x - startingMouse.x;
    draggedItem.y = mouse.y + posnInWindow.y - startingMouse.y;
    if(win.snapToGrid) {
        draggedItem.x = Math.round(draggedItem.x / win.gridSize) * win.gridSize;
        draggedItem.y = Math.round(draggedItem.y / win.gridSize) * win.gridSize;
    }
}

function endDrag(mouse)
{
    if (draggedItem == null)
        return;

    if (draggedItem.y > scene.height || draggedItem.x > scene.width) {
        draggedItem.destroy();
        draggedItem = null;
    } else {
        draggedItem.created = true;
        scene.originalProperties.push({"item": draggedItem, "x": draggedItem.x, "y": draggedItem.y});
        draggedItem = null;
    }
}
