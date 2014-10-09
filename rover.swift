class MarsRover {
  var position: Position = Position(x: 0, y: 0)
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

//Tests

func marsRoverTests() {
	let rover = MarsRover()
	assert(rover.position == Position(x: 0, y: 0))
}

func positionTests() {
  let originalPosition = Position(x: 10, y: 100)
  let equalPosition = Position(x: 10, y: 100)
  let differentPosition = Position(x: 0, y: 0)
  
  assert(originalPosition == equalPosition)
  assert(originalPosition != differentPosition)
}

marsRoverTests()
positionTests()
println("All tests passed")