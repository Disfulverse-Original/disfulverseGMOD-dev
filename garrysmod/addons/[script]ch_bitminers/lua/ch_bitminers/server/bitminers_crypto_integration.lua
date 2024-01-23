net.Receive( "CH_BITMINERS_CryptoIntegration_SelectCrypto", function( length, ply )
	local bitminer = net.ReadEntity()
	local crypto_index = net.ReadUInt( 6 )
	
	-- Withdraw before changing
	if bitminer:GetBitcoinsMined() > 0 then
		bitminer:WithdrawInCrypto( ply )
	end
	
	-- Change the crypto in the bitminer and let the player know
	bitminer:SetCryptoIntegrationIndex( crypto_index )
	DarkRP.notify( ply, 1, 5, CH_CryptoCurrencies.LangString( "Your bitminer is now mining" ) .." ".. CH_CryptoCurrencies.Cryptos[ crypto_index ].Name )
end )