<?php

declare(strict_types=1);

use Laminas\Mvc\Application;
use Laminas\Stdlib\ArrayUtils;

/**
 * This makes our life easier when dealing with paths. Everything is relative
 * to the application root now.
 */
chdir(dirname(__DIR__));

// Decline static file requests back to the PHP built-in webserver
if (php_sapi_name() === 'cli-server') {
    $path = realpath(__DIR__ . parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH));
    if (is_string($path) && __FILE__ !== $path && is_file($path)) {
        return false;
    }
    unset($path);
}

// Set default timezone if not available in php.ini
if (!ini_get('date.timezone')) {
    date_default_timezone_set('UTC');
}

// Set paths
$path =  [
    'autoload'   => __DIR__ . '/../vendor/autoload.php',
    'app_config' => __DIR__ . '/../config/application.config.php',
    'dev_config' => __DIR__ . '/../config/development.config.php',
];

// Composer autoloading
include realpath($path['autoload']);

if (! class_exists(Application::class)) {
    throw new RuntimeException(
        "Unable to load application.\n"
        . "- Type `composer install` if you are developing locally.\n"
        . "- Type `vagrant ssh -c 'composer install'` if you are using Vagrant.\n"
        . "- Type `docker-compose run laminas composer install` if you are using Docker.\n"
    );
}

// Retrieve configuration
$appConfig = require realpath($path['app_config']);
if (file_exists($path['dev_config'])) {
    $appConfig = ArrayUtils::merge($appConfig, require realpath($path['dev_config']));
}

// Run the application!
Application::init($appConfig)->run();
