<?php namespace PragmaRX\Skeleton\Vendor\Laravel;
 
use PragmaRX\Skeleton\Skeleton;

use PragmaRX\Skeleton\Support\Config;
use PragmaRX\Skeleton\Support\FileSystem;

use PragmaRX\Skeleton\Data\Repositories\RepositoryExample;

use PragmaRX\Skeleton\Data\RepositoryManager;

use PragmaRX\Skeleton\Vendor\Laravel\Models\ModelExample;

use Illuminate\Support\ServiceProvider as IlluminateServiceProvider;
use Illuminate\Foundation\AliasLoader as IlluminateAliasLoader;

class ServiceProvider extends IlluminateServiceProvider {

    const PACKAGE_NAMESPACE = 'pragmarx/skeleton';

    /**
     * Indicates if loading of the provider is deferred.
     *
     * @var bool
     */
    protected $defer = false;

    /**
     * Bootstrap the application events.
     *
     * @return void
     */
    public function boot()
    {
        $this->package(self::PACKAGE_NAMESPACE, self::PACKAGE_NAMESPACE, __DIR__.'/../..');

        if( $this->app['config']->get(self::PACKAGE_NAMESPACE.'::create_skeleton_alias') )
        {
            IlluminateAliasLoader::getInstance()->alias(
                                                            $this->getConfig('skeleton_alias'),
                                                            'PragmaRX\Skeleton\Vendor\Laravel\Facade'
                                                        );
        }

        $this->wakeUp();
    }

    /**
     * Register the service provider.
     *
     * @return void
     */
    public function register()
    {   
        $this->registerConfig();

        $this->registerRepositories();

        $this->registerSkeleton();
    }

    /**
     * Get the services provided by the provider.
     *
     * @return array
     */
    public function provides()
    {
        return array('skeleton');
    }

    /**
     * Takes all the components of Skeleton and glues them
     * together to create Skeleton.
     *
     * @return void
     */
    private function registerSkeleton()
    {
        $this->app['skeleton'] = $this->app->share(function($app)
        {
            $app['skeleton.loaded'] = true;

            return new Skeleton(
                                    $app['skeleton.config'],
                                    $app['skeleton.repository.manager']
                                );
        });
    }

    public function registerRepositories()
    {
        $this->app['skeleton.repository.manager'] = $this->app->share(function($app)
        {
            return new RepositoryManager(
                                            $app['skeleton.config'],
                                            new RepositoryExample(new ModelExample)
                                        );
        });
    }

    public function registerConfig()
    {
        $this->app['skeleton.config'] = $this->app->share(function($app)
        {
            return new Config($app['config'], self::PACKAGE_NAMESPACE);
        });
    }

    private function wakeUp()
    {
        $this->app['skeleton']->boot();
    }

    private function getConfig($key)
    {
        return $this->app['config']->get(self::PACKAGE_NAMESPACE.'::'.$key);
    }

}
