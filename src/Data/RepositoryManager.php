<?php

/**
 * Part of the Skeleton package.
 *
 * NOTICE OF LICENSE
 *
 * Licensed under the 3-clause BSD License.
 *
 * This source file is subject to the 3-clause BSD License that is
 * bundled with this package in the LICENSE file.  It is also available at
 * the following URL: http://www.opensource.org/licenses/BSD-3-Clause
 *
 * @package    Skeleton
 * @version    1.0.0
 * @author     Antonio Carlos Ribeiro @ PragmaRX
 * @license    BSD License (3-clause)
 * @copyright  (c) 2013, PragmaRX
 * @link       http://pragmarx.com
 */

namespace PragmaRX\Skeleton\Data;

use PragmaRX\Skeleton\Support\Config;

use PragmaRX\Skeleton\Data\Repositories\RepositoryExample;

class RepositoryManager implements RepositoryManagerInterface {

    private $config;

	private $repositoryExample;

    public function __construct(Config $config, RepositoryExample $repositoryExample)
    {
        $this->config = $config;

    	$this->repositoryExample = $repositoryExample;
    }

}
