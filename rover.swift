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
  let planet: Planet

  init(planet: Planet, position: Position) {
    self.planet = planet
    self.position = position
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

func positionTests() {
  let originalPosition = Position(x: 10, y: 100)
  let equalPosition = Position(x: 10, y: 100)
  let differentPosition = Position(x: 0, y: 0)
  
  assert(originalPosition == equalPosition)
  assert(originalPosition != differentPosition)
}

marsRoverTests()
planetTests()
positionTests()
println("All tests passed")