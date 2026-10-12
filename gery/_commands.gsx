/*
 * ============================================================
 *  COD4X - Blitz
 *  Version: 3.2
 *  Developer: Gery Kurucz (github.com/gerykurucz)
 * ============================================================
 */

init()
{
	addscriptcommand( "unlock", 1 );
}

commandHandler( cmd, arg )
{
	self endon( "disconnect" );
	level endon( "game_ended" );

	if( !isDefined( self.pers["unlockState"] ) )
		self.pers["unlockState"] = 0;

	switch( toLower( cmd ) )
	{
		case "unlock":
			if( self.pers["unlockState"] == 0 )
			{
				self thread gery\_unlockall::init();
			}
			else
			{
				self iPrintlnBold( "Your profile has been unlocked already!" );
			}
			break;
	}
	wait 0.05;
}

rconSupport()
{
	setDvar( "cmd", "" );

	for(;;)
	{
		if( getDvar( "cmd" ) != "" )
		{
			data = strTok( getDvar("cmd"), ":" );

			if( isDefined( data[ 0 ] ) && isDefined( data[ 1 ] ) )
			{
				thread processRcon( data );
				setDvar( "cmd", "" );
			}
		}

		wait .05;
	}
}

processRcon( data )
{
	cmd = data[ 0 ];

	if( data[ 1 ].size > 2 || !isInt( data[ 1 ] ) )
		return;

	player = getEntByNum( int( data[ 1 ] ) );

	if( !isPlayer( player ) )
		return;

	if( isDefined( data[ 2 ] ) )
		args = data[ 2 ];
	else
		args = "";

	player thread commandHandler( cmd, args );
}

isInt( s )
{
	for( i = 0; i < s.size; i++ )
	{
		if( s[ i ] != "0" && !int( s[ i ] ) )
		{
			return false;
		}
	}

	return true;
}