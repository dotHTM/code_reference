//#-hidden-code
_setup()
//#-end-hidden-code
//#-editable-code
import Foundation

typealias Folds = Array<Bool>

struct DragonBrain {
    var foldLists : [[Bool]] = []
    var currentIteration : Int {
        get{ return foldLists.count }
    }
    func flatFoldList(_ thruIteration: Int) -> [Bool]{
    var result : [Bool] = []
    result.reserveCapacity(
    2^currentIteration-1)
    if thruIteration <= currentIteration {
    foldLists[0..<thruIteration].forEach({ result.append(contentsOf: $0) })
    }
    return result
    }
    func flatFoldList() -> [Bool] {
    return flatFoldList(currentIteration)
    }
    
    mutating func nextIteration(){
        var newFolds = [true]
        newFolds.reserveCapacity(
            2^currentIteration-1)
        foldLists.joined().reversed().forEach({newFolds.append(!$0)})
        foldLists.append(newFolds)
    }
    
    mutating func iterationUpTo(someIteration: Int)
    { while someIteration > currentIteration { nextIteration() } }
    
    init(_ startingIteration: Int){
        for i in 1 ... startingIteration {
            nextIteration()
        }
    }
    init(){}
}

struct VectorPoint {
    var origin : Point
    var direction : Double
    var magnitude : Double
    var magnitudePoint: Point{
        get{
            let x = origin.x + magnitude * cos (direction)
            let y = origin.y + magnitude * sin (direction)
            return Point(x: x, y: y)
        }
    }
    mutating func moveToMagnitude(){
        origin = magnitudePoint
    }
    mutating func changeDirection(newDirection: Double){
        direction = newDirection
    }
}

struct drawSpace {
    let stepRadius : Double
    let stepAngle : Double
    var vector : VectorPoint
    var turniningAngle = 0.0
    
    init(){
        self.init(stepDist: 0.5, angle : Double.pi / 2  , origin: Point(x: 0, y:0), originDirection: 0.0)
    }
    
    init(stepDist: Double, angle : Double , origin: Point, originDirection: Double){
        stepRadius = stepDist
        stepAngle = angle
        vector = VectorPoint(origin: origin, direction: originDirection, magnitude: stepRadius)
        
        lineDraw()
    }
    
    mutating func appendDraw(anFold: Bool, inputColor: Double){
        if anFold { turniningAngle = stepAngle}
        else { turniningAngle = -stepAngle }
        
        vector.moveToMagnitude()
        vector.changeDirection(newDirection: vector.direction + turniningAngle )
        
        var myLine = Line(start: vector.origin, end: vector.magnitudePoint, thickness: 0.1)
        myLine.color = Color.init(hue: inputColor, saturation: 1.0, brightness: 1.0)
    }
    
    func backgroundPrep(color: Color)
    {
        var background =
            Rectangle(width: 1000, height: 1000)
        background.color = color
    }
    
    enum TurnDirection{
        case left
        case right
    }
    
    mutating func turn(_ direction: TurnDirection) {
        let angle: Double
        switch direction {
        case .left:
            angle = stepAngle
        default:
            angle = -stepAngle
        }
        vector.changeDirection(newDirection: vector.direction + angle )
    }
    var drawing : [Line] = []
    
    func rotate() {
        for anLine in drawing{
            anLine.rotation += Double.pi/3
        }
    }
    
    mutating func lineDraw( color: Color ) {
        var someLine = Line(start: vector.origin, end: vector.magnitudePoint, thickness: 0.1)
        vector.moveToMagnitude()
        someLine.color = color
        drawing.append(someLine)
    }
    
    mutating func lineDraw() {
        lineDraw( color: Color.black )
    }
    
    func spinAMathing(
        angle: Double,
        duration: Double,
        delay: Double){
        for i in 0 ..< drawing.count {
            let someLine = drawing[i]
            animate (
                duration: duration,
                delay: Double(i) * delay
            ){
                someLine.rotation += angle
            }
        }
    }
    
    func thickAMathing(
        thickness: Double,
        duration: Double,
        delay: Double,
        offset: Double){
        for i in 0 ..< drawing.count {
            let someLine = drawing[i]
            animate (
                duration: duration,
                delay: (Double(i) * delay) + offset
            ){
                someLine.thickness += thickness
            }
        }
    }
    
    func scaleChange(_ deltaScale: Double){
        for anLine in drawing{
            anLine.start.x *= 1.0 + deltaScale
            anLine.start.y *= 1.0 + deltaScale
            anLine.end.x *= 1.0 + deltaScale
            anLine.end.y *= 1.0 + deltaScale
        }
    }
    
    func translate(_ deltaPoint: Point){
        for anLine in drawing{
            anLine.start.x += deltaPoint.x
            anLine.start.y += deltaPoint.y
            anLine.end.x += deltaPoint.x
            anLine.end.y += deltaPoint.y
        }
    }
    
}

struct MyUIButton {
    var buttonBody = Circle(radius: 4)
    var textLabel = Text(string: "Hello world")
    var touchableSurface = Circle(radius: 5)
    let inactiveColor : Color
    let activeColor : Color
    
    var string : String{
        get { return textLabel.string }
        set {textLabel.string = newValue
        }
    }
    var size : Double {
        get{ return buttonBody.radius }
        set{
            buttonBody.radius = newValue
            touchableSurface.radius = newValue + 1
        }
    }
    var center : Point {
        get{ return buttonBody.center }
        set{
            buttonBody.center = newValue
            textLabel.center = newValue
            touchableSurface.center = newValue
        }
    }
    
    func onTouchDown(_ f: @escaping ()->Void ){
        touchableSurface.onTouchDown {
            self.buttonBody.color = self.activeColor
            f()
        }
    }
    
    func onTouchUp(_ f: @escaping ()->Void ){
        touchableSurface.onTouchUp {
            self.buttonBody.color = self.inactiveColor
            f()
        }
    }
    
    init(text: String, radius: Double, location: Point, inactiveColor: Color, activeColor: Color){
        touchableSurface.color =
            Color( white: 0.75,
                   alpha: 0.25)
        self.inactiveColor = inactiveColor
        self.activeColor = activeColor
        buttonBody.color = inactiveColor
        
        self.onTouchDown{}
        self.onTouchUp{}
        string = text
        size = radius
        center = location
        
        
    }
    init(){
        self.init(text: "Hello World", radius: 4, location: Point(x: 0, y: 0) , inactiveColor: .blue, activeColor: .red)
    }
}

/* ---- ---- ---- ---- */


let myDragon = DragonBrain(8)

var myDrawSpace = drawSpace(
    stepDist: 2,
    angle: Double.pi / 2 ,
    origin: Point(x: 10, y: 15),
    originDirection: Double.pi * Double(myDragon.currentIteration - 3) / 4
)

for anTurnList in myDragon.foldLists
{
    for anTurn in anTurnList {
        if anTurn { myDrawSpace.turn(.left) }
        else { myDrawSpace.turn(.right) }
        myDrawSpace.lineDraw()
    }
}



var spinButton =
    MyUIButton(
        text: "🌀",
        radius: 4,
        location:
        Point(x: 20, y: -26),
        inactiveColor: .green,
        activeColor: .orange)


spinButton.onTouchDown {
    myDrawSpace.spinAMathing(angle: Double.pi , duration: 1, delay: 0.01)
}

spinButton.onTouchUp {
    myDrawSpace.spinAMathing(angle: -Double.pi, duration: 1, delay: 0.01)
}



var thickButton =
    MyUIButton(
        text: "thick",
        radius: 4,
        location:
        Point(x: 20, y: -15),
        inactiveColor: .green,
        activeColor: .orange)


thickButton.onTouchDown {
    myDrawSpace.thickAMathing(thickness: 0.3 , duration: 1, delay: 0.01, offset: 0.0)
}
thickButton.onTouchUp {
    myDrawSpace.thickAMathing(thickness: -0.3 , duration: 1, delay: 0.01, offset: 0.05)
}


let scaleFactor = 0.2

var scaleUpButton =
    MyUIButton(
        text: "+",
        radius: 4,
        location:
        Point(x: -20, y: -15),
        inactiveColor: .green,
        activeColor: .orange)


scaleUpButton.onTouchDown {
    myDrawSpace.scaleChange(scaleFactor)
}

var scaleDownButton =
    MyUIButton(
        text: "-",
        radius: 4,
        location:
        Point(x: -20, y: -26),
        inactiveColor: .green,
        activeColor: .orange)

scaleDownButton.onTouchDown {
    myDrawSpace.scaleChange(-scaleFactor)
}

var moveRightButton =
    MyUIButton(
        text: ">",
        radius: 3,
        location:
        Point(x: 8, y: -20.5),
        inactiveColor: .green,
        activeColor: .orange)

moveRightButton.onTouchDown {    myDrawSpace.translate(Point(x: 1, y: 0))
}


var moveLeftButton =
    MyUIButton(
        text: "<",
        radius: 3,
        location:
        Point(x: -8, y: -20.5),
        inactiveColor: .green,
        activeColor: .orange)

moveLeftButton.onTouchDown {    myDrawSpace.translate(Point(x: -1, y: 0))
}
var moveUpButton =
    MyUIButton(
        text: "^",
        radius: 3,
        location:
        Point(x: 0, y: -15),
        inactiveColor: .green,
        activeColor: .orange)


moveUpButton.onTouchDown {
    myDrawSpace.translate(Point(x: 0, y: 1))
}

var moveDownButton =
    MyUIButton(
        text: "v",
        radius: 3,
        location:
        Point(x: 0, y: -26),
        inactiveColor: .green,
        activeColor: .orange)


moveDownButton.onTouchDown {
    myDrawSpace.translate(Point(x: 0, y: -1))
}



//#-end-editable-code
