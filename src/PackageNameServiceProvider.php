<?php namespace :VendorName\:PackageName;

use Illuminate\Support\ServiceProvider;

class :PackageNameServiceProvider extends ServiceProvider {

	/**
	 * Indicates if loading of the provider is deferred.
	 *
	 * @var bool
	 */
	protected $defer = false;

	/**
	 * Register the service provider.
	 *
	 * @return void
	 */
	public function register()
	{
		//
	}

	/**
	 * Boot the service provider.
	 *
	 * @return void
	 */
	public function boot()
	{
		$this->publishViews();

		$this->publishTranslations();

		$this->publishConfiguration();

		$this->publishMigrations();
	}

	/**
	 * Load package views.
	 *
	 */
	protected function publishViews()
	{
		$this->loadViewsFrom(__DIR__ . '/views', ':package_name');

		$this->publishes([
			__DIR__ . '/views' => base_path('resources/views/vendor/:package_name'),
		]);
	}

	/**
	 * Load package translations.
	 *
	 */
	protected function publishTranslations()
	{
		$this->loadTranslationsFrom(__DIR__.'/lang', ':package_name');
	}

	/**
	 * Publish configuration.
	 *
	 */
	protected function publishConfiguration()
	{
		$this->publishes([
		    __DIR__.'/config/config.php' => config_path(':package_name.php'),
		]);
	}

	/**
	 * Publish configuration.
	 *
	 */
	protected function publishMigrations()
	{
		$this->publishes([
			__DIR__.'/database/migrations/' => base_path('/database/migrations')
		], 'migrations');
	}

	/**
	 * Get the services provided by the provider.
	 *
	 * @return array
	 */
	public function provides()
	{
		return array();
	}

}
