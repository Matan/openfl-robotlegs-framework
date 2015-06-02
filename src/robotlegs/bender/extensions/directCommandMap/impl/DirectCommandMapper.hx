//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.directCommandMap.impl;

import robotlegs.bender.extensions.commandCenter.api.ICommand;
import robotlegs.bender.extensions.commandCenter.api.ICommandExecutor;
import robotlegs.bender.extensions.commandCenter.api.ICommandMapping;
import robotlegs.bender.extensions.commandCenter.api.ICommandMappingList;
import robotlegs.bender.extensions.commandCenter.impl.CommandMapping;
import robotlegs.bender.extensions.commandCenter.api.CommandPayload;
import robotlegs.bender.extensions.directCommandMap.dsl.IDirectCommandConfigurator;

/**
 * @private
 */

@:keepSub
class DirectCommandMapper implements IDirectCommandConfigurator
{

	/*============================================================================*/
	/* Private Properties                                                         */
	/*============================================================================*/

	private var _mappings:ICommandMappingList;

	private var _mapping:ICommandMapping;

	private var _executor:ICommandExecutor;

	/*============================================================================*/
	/* Constructor                                                                */
	/*============================================================================*/

	/**
	 * @private
	 */
	public function new(executor:ICommandExecutor, mappings:ICommandMappingList, commandClass:Class<ICommand>)
	{
		_executor = executor;
		_mappings = mappings;
		_mapping = new CommandMapping(commandClass);
		_mapping.setFireOnce(true);
		_mappings.addMapping(_mapping);
	}

	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/

	/**
	 * @inheritDoc
	 */
	public function withExecuteMethod(name:String):IDirectCommandConfigurator
	{
		_mapping.setExecuteMethod(name);
		return this;
	}

	/**
	 * @inheritDoc
	 */
	public function withGuards(guards:Array<Dynamic>):IDirectCommandConfigurator
	{
		Reflect.callMethod (null, _mapping.addGuards, guards);
		//_mapping.addGuards.apply(null, guards);
		return this;
	}

	/**
	 * @inheritDoc
	 */
	public function withHooks(hooks:Array<Dynamic>):IDirectCommandConfigurator
	{
		Reflect.callMethod (null, _mapping.addHooks, hooks);
		//_mapping.addHooks.apply(null, hooks);
		return this;
	}

	/**
	 * @inheritDoc
	 */
	public function withPayloadInjection(value:Bool = true):IDirectCommandConfigurator
	{
		_mapping.setPayloadInjectionEnabled(value);
		return this;
	}

	/**
	 * @inheritDoc
	 */
	public function execute(payload:CommandPayload = null):Void
	{
		_executor.executeCommands(_mappings.getList(), payload);
	}

	/**
	 * @inheritDoc
	 */
	public function map(commandClass:Class<ICommand>):IDirectCommandConfigurator
	{
		return new DirectCommandMapper(_executor, _mappings, commandClass);
	}
}