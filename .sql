/*
Downloading mysql in bash

Update your package list to avoid installing an outdated version of mysql.
    =========================================
    sudo apt update
    =========================================

    =========================================
    sudo apt install mysql-server
    sudo mysql_secure_installation
    =========================================
or
    =========================================
    sudo apt install mariadb-server mariadb-client -y
    =========================================
depending on what OS you are using.


Checking if mysql is running
    =========================================
    sudo systemctl status mysql
    =========================================

Type:
    =========================================
    sudo mysql -u root -p
    =========================================
or
    =========================================
    sudo mysql
    =========================================
to use mysql
*/

SET GLOBAL validate_password.policy = LOW;
SET GLOBAL validate_password.length = 1;


CREATE DATABASE card_game;

/*
test is a placeholder and can be changed.
IDENTIFIED BY 'your_password'
*/
CREATE USER 'test'@'%' IDENTIFIED BY 'test';
GRANT ALL PRIVILEGES ON card_game.* TO 'test'@'%';
FLUSH PRIVILEGES;

USE card_game;

CREATE TABLE active_games (
    id INT AUTO_INCREMENT PRIMARY KEY,
    lobby_name VARCHAR(50) NOT NULL,
    lobby_password VARCHAR(50),

    playing INT DEFAULT 0,
    placed_cards JSON,
    untouched_cards JSON
);
DESCRIBE active_games;

CREATE TABLE players (
    id INT DEFAULT 0,
    name VARCHAR(50) NOT NULL,
    ip_address VARCHAR(50) NOT NULL,

    game_id INT NOT NULL,
    FOREIGN KEY (game_id) REFERENCES active_games(id),
    cards JSON
);
DESCRIBE players;


DELIMITER $$

CREATE TRIGGER on_player_join
BEFORE INSERT ON players
FOR EACH ROW
BEGIN
    SET NEW.id = (
        SELECT playing + 1 
        FROM active_games
        WHERE active_games.id = NEW.game_id
        LIMIT 1
    );

    UPDATE active_games
    SET playing = playing + 1
    WHERE active_games.id = NEW.game_id;
END$$

DELIMITER ;


DELIMITER $$

CREATE TRIGGER on_player_leave
BEFORE DELETE ON players
FOR EACH ROW
BEGIN
    UPDATE active_games
    SET playing = playing - 1
    WHERE active_games.id = OLD.game_id;
END$$

DELIMITER ;


/* Test it */
INSERT INTO active_games (lobby_name) VALUES ('test');
SELECT * FROM active_games;
/*
It should show that there is 1 game with 0 players. Now we will add a player to the game and see if the player count increases.
*/

INSERT INTO players (name, ip_address, game_id) VALUES ('test', 'dwadwa', 1);
SELECT * FROM players;
SELECT * FROM active_games;
/*
It should show that there is 1 player row with the game_id of 1 and the player count in the active_games table should be 1.
*/

DELETE FROM players WHERE id = 1;
SELECT * FROM players;
SELECT * FROM active_games;
/*
It should show that there are no players and the player count in the active_games table should be 0.
*/