# DudleTokenBurn

Token with devidends system. Non-iterable and iterable mapping way.

In line 80 of DudleToken contract created a function for take eth, share it amoung token holders and send it to them. (Itarable mapping)

ItrableMaping is a librari using in DudleToken contract for iterate holders mapping, in order to send the eth to all of them in proportion after deposit.

In Devidends contract created a function takeReward that works without iterable mapping way. Holders just need to take their reward in time. 