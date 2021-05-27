<?php

/**
 * @param string $path
 * @return void
 */
function recursiveRemovePath($path)
{
    if (is_file($path) || is_link($path)) {
        unlink($path);
        return;
    }

    if (! is_dir($path)) {
        return;
    }

    foreach (scandir($path) as $object) {
        if ($object === '.' || $object === '..') {
            continue;
        }

        recursiveRemovePath($path . '/' . $object);
    }

    rmdir($path);
}

$githubDir = dirname(__DIR__) . '/.github';
if (is_dir($githubDir)) {
    recursiveRemovePath($githubDir);
}

unlink(__FILE__);
