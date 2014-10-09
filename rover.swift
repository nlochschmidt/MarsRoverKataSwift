class MarsRover {

  var landingPlace: Position

  init(startingPoint: (Int, Int)) {
    let (x, y) = startingPoint
    landingPlace = Position(x: x, y: y)
  }

  func land(planet: Planet) -> LandedMarsRover {
    let targetPosition = planet.locate(landingPlace)
    return LandedMarsRover(planet: planet, position: targetPosition)
  }
}

class LandedMarsRover {
  
  var position: Position
  var direction: Direction = .North
  let planet: Planet

  init(planet: Planet, position: Position) {
    self.planet = planet
    self.position = position
  }

  func move(commands: String) {
    for command in commands {
      switch command {
        case "f": 
          self.position = planet.locate(position + direction.relativePosition())
        case "b":
          self.position = planet.locate(position - direction.relativePosition())
        default: return
      }   
    }
  }
}



enum Direction: Int {
  case North, East, South, West

  func relativePosition() -> Position {
    switch self {
    case .North: return Position(x: 0, y: 1)
    case .South: return Position(x: 0, y: -1)
    case .West: return Position(x: -1, y: 0)
    case .East: return Position(x: 1, y: 0)
    default: return Position(x: 0, y: 0)
    }
  }
}

class Position : Equatable {
  let x: Int
  let y: Int
  
  init(x: Int, y: Int) {
    self.x = x
    self.y = y
  }
}

func +(originalPosition: Position, relativePosition: Position) -> Position {
  return Position(
    x: originalPosition.x + relativePosition.x, 
    y: originalPosition.y + relativePosition.y)
}

prefix func -(position: Position) -> Position {
  return Position(
    x: -position.x,
    y: -position.y)
}

func -(originalPosition: Position, relativePosition: Position) -> Position {
  return originalPosition + (-relativePosition)
}

func ==(left: Position, right: Position) -> Bool {
  return left.x == right.x && left.y == right.y
}

struct Planet: Equatable {
  let name: String
  let sizeX: Int
  let sizeY: Int

  func locate(position: Position) -> Position {
    let x = position.x % sizeX
    let y = position.y % sizeY

    func wrap(coord: Int, max: Int) -> Int {
      let remainder = coord % max
      if (remainder >= 0) {
        return remainder
      } else {
        return max + remainder
      }
    }

    return Position(
      x: wrap(position.x, sizeX), 
      y: wrap(position.y, sizeY))
  }
}

func ==(left: Planet, right: Planet) -> Bool {
  return left.name == right.name && left.sizeX == right.sizeX && left.sizeY == right.sizeY
}

//Tests

let mars = Planet(name: "Mars", sizeX: 100, sizeY: 100)

func test(test: () -> ()) {
  test()
}

func marsRoverTests() {
  //create a mars rover
  test({ 
    () -> () in
    let rover = MarsRover(startingPoint: (0, 0))
	  assert(rover.landingPlace == Position(x: 0, y: 0))
  })  

  //land it on mars
  test({
    () -> () in
    let rover = MarsRover(startingPoint: (0, 0))
    let landedRover = rover.land(mars)
    assert(landedRover.planet == mars)
    assert(landedRover.direction == .North)
  })
}

func landedMarsRoverTests() {
  func landedMarsRover() -> LandedMarsRover {
    let rover = MarsRover(startingPoint: (0, 0))
    return rover.land(mars)
  }

  test({
    () -> () in 
    let landedRover = landedMarsRover()
    landedRover.move("f")
    assert(landedRover.position == Position(x: 0, y: 1))
  })

  test({
    () -> () in 
    let landedRover = landedMarsRover()
    landedRover.move("b")
    assert(landedRover.position == Position(x: 0, y: 99))
  })
}

func planetTests() {

  //test location wrapping on planet
  test({
    () -> () in
    let positionOnMars = mars.locate(Position(x: mars.sizeX, y: mars.sizeY))
    assert(positionOnMars == Position(x: 0, y: 0))
  })

  test({
    () -> () in
    let positionOnMars = mars.locate(Position(x: -1, y: -1))
    assert(positionOnMars == Position(x: mars.sizeX-1, y: mars.sizeY-1))
  })
}

func directionTests() {
  //test relativePosition from Direction
  test({
    () -> () in 
    assert(Direction.North.relativePosition() == Position(x: 0, y: 1))
    assert(Direction.South.relativePosition() == Position(x: 0, y: -1))
    assert(Direction.West.relativePosition() == Position(x: -1, y: 0))
    assert(Direction.East.relativePosition() == Position(x: 1, y: 0))
  })
}

func positionTests() {
  
  // test equality
  test({
    () -> () in
    let originalPosition = Position(x: 10, y: 100)
    let equalPosition = Position(x: 10, y: 100)
    let differentPosition = Position(x: 0, y: 0)
    
    assert(originalPosition == equalPosition)
    assert(originalPosition != differentPosition)
  })

  // test position adding
  test({
    () -> () in
    let originalPosition = Position(x: 10, y: 20)
    let relativePosition = Position(x: -5, y: 5)
  
    let resultingPosition = Position(x: 5, y: 25)
    
    assert((originalPosition + relativePosition) == resultingPosition)
  })
}

marsRoverTests()
landedMarsRoverTests()
planetTests()
positionTests()
directionTests()
println("All tests passed")
