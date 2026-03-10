/*
Downloading mysql

sudo apt update
sudo apt install mysql-server
sudo systemctl status mysql
sudo mysql_secure_installation


sudo mysql -u root -p
or
sudo mysql
*/

SET GLOBAL validate_password.policy = LOW;
SET GLOBAL validate_password.length = 1;


CREATE DATABASE card_game;

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