import 'package:flutter/material.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override 
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {

  bool oTurn = true;
  bool gameActive = true;
  bool roundWon = false;
  bool roundDraw = false;


  List<String> displayValues = [
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
  ];
  List<List> winningConditions = [
    [0, 1, 2],
    [3, 4, 5],
    [6, 7, 8],
    [0, 3, 6],
    [1, 4, 7],
    [2, 5, 8],
    [0, 4, 8],
    [2, 4, 6]
];
  List matchedBox = [];

  static const whiteTextLarge = TextStyle(
    color: Colors.white,
    fontSize: 50
  );

  static const whiteTextMedium = TextStyle(
    color: Colors.white,
    fontSize: 30
  );

  String message = "Click on a box to start. Player 'o' starts the game." ;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(50),
        child: Column(
        children: [
          Expanded(
            flex: 1,
            child: Column(
              children: [
                const Center(
                  child: Text(
                    'Tic Tac Toe', 
                    style: whiteTextLarge
                  )
                ),
                Center(
                  child: GestureDetector(
                    child: Container(
                      margin: const EdgeInsets.all(25),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: const Text('Restart', style: TextStyle(color: Colors.black, fontSize: 20))
                    ),
                    onTap: () {
                      _restartGame();
                    },
                  )
                ),
              ],
            )
            
          ),
          Expanded(
            flex: 3,
            child: GridView.builder(
              itemCount: 9,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3), 
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    _boxClick(index);
                  },
                  child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          width: 5,
                          color: Colors.black
                        ),
                        color: matchedBox.contains(index)? Colors.lightGreen : Colors.cyan
                      ),
                      child: Center(child: Text(displayValues[index], style: whiteTextLarge)),
                    ),
                );
              }),
          ),
          Expanded(
            flex: 1,
            child: Text(message, style: whiteTextMedium),
          ),
        ],
      ),
      )
    );
  }

  void _boxClick(int index) {
    setState(() {
      if (displayValues[index] != "" || !gameActive) {
        return;
    }
      if (displayValues[index] == '') {
        displayValues[index] = oTurn ? 'o': 'x';
      } 
      _handleResultValidation();
      if(!roundWon && !roundDraw){
        oTurn = !oTurn;
        _setMessage('type');
      }

    });
  }

  String _setMessage(type) {
    String currentPlayer = oTurn ? "Player 'o'" : "Player 'x'" ;
    if(type == 'win') {
      message = '$currentPlayer is the Winner!';
    } else if(type == 'draw') {
      message = 'Game ended in a draw!';
    } else {
      message = "It's $currentPlayer's turn";
    }
    return message;
  }

  
void _handleResultValidation() {
    for (int i = 0; i <= 7; i++) {
        List winCondition = winningConditions[i];
        String a = displayValues[winCondition[0]];
        String b = displayValues[winCondition[1]];
        String c = displayValues[winCondition[2]];
        if (a == '' || b == '' || c == '') {
            continue;
        }
        if (a == b && b == c) {
            roundWon = true;
            matchedBox = winningConditions[i];
            debugPrint('win----${winningConditions[i]}');
            break;
        }
    }
  if (roundWon) {
        _setMessage('win');
        gameActive = false;
        return;
    }
  /* 
  We will check weather there are any values in our game state array 
  that are still not populated with a player sign
  */
    roundDraw = !displayValues.contains("");
    if (roundDraw) {
        _setMessage('draw');
        gameActive = false;
        return;
    }
  }

  void _restartGame() {
    debugPrint('RESTARTTTTTTTTTTT');
    setState(() {
      gameActive = true;
      oTurn = true;
      roundDraw = false;
      roundWon = false;
      displayValues = ["", "", "", "", "", "", "", "", ""];
      message = "Click on a box to start. Player 'o' starts the game.";
      matchedBox = [];
    });
}
}
