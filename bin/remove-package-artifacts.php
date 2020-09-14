<?php

/**
 * This file is triggered by the post-create-project-cmd event in order to
 * remove the github workflows used by the package, as well as this file itself.
 *
 * @see       https://github.com/laminas/laminas-mvc-skeleton for the canonical source repository
 * @copyright https://github.com/laminas/laminas-mvc-skeleton/blob/master/COPYRIGHT.md
 * @license   https://github.com/laminas/laminas-mvc-skeleton/blob/master/LICENSE.md New BSD License
 */

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
