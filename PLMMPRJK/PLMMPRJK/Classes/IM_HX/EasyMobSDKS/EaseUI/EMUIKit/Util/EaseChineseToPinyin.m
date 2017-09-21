/************************************************************
 *  * Hyphenate CONFIDENTIAL
 * __________________
 * Copyright (C) 2016 Hyphenate Inc. All rights reserved.
 *
 * NOTICE: All information contained herein is, and remains
 * the property of Hyphenate Inc.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from Hyphenate Inc.
 */

#import "EaseChineseToPinyin.h"

NSString *FindLetter(int nCode)
{
	NSString *strValue = @"";
	switch(nCode) {
		case 6325:
		case 6436:
		case 7571:
		case 7925:
			strValue = @"A";
			break;
		case 6263:
		case 6440:
		case 7040:
		case 7208:
		case 7451:
		case 7733:
		case 7945:
		case 8616:
			strValue = @"AI";
			break;
		case 5847:
		case 5991:
		case 6278:
		case 6577:
		case 6654:
		case 7281:
		case 7907:
		case 8038:
		case 8786:
			strValue = @"AN";
			break;
//			strValue = @"ANG";
//			break;
		case 5974:
		case 6254:
		case 6427:
		case 6514:
		case 6658:
		case 6959:
		case 7033:
		case 7081:
		case 7365:
		case 8190:
		case 8292:
		case 8643:
		case 8701:
		case 8773:
			strValue = @"AO";
			break;
		case 6056:
		case 6135:
		case 6517:
		case 7857:
		case 8446:
		case 8649:
		case 8741:
			strValue = @"BA";
			break;
		case 6267:
		case 6334:
		case 7494:
			strValue = @"BAI";
			break;
		case 5870:
		case 5964:
		case 7851:
		case 8103:
		case 8113:
		case 8418:
			strValue = @"BAN";
			break;
		case 6182:
		case 6826:
			strValue = @"BANG";
			break;
		case 6165:
		case 7063:
		case 7650:
		case 8017:
		case 8157:
		case 8532:
		case 8621:
			strValue = @"BAO";
			break;
		case 5635:
		case 5873:
		case 5893:
		case 5993:
		case 6141:
		case 6703:
		case 7753:
		case 8039:
		case 8156:
		case 8645:
		case 8725:
			strValue = @"BEI";
			break;
		case 5946:
		case 5948:
		case 7458:
		case 7928:
			strValue = @"BEN";
			break;
		case 6452:
		case 7420:
			strValue = @"BENG";
			break;
		case 5616:
		case 5734:
		case 6074:
		case 6109:
		case 6221:
		case 6333:
		case 6357:
		case 6589:
		case 6656:
		case 6725:
		case 6868:
		case 6908:
		case 6986:
		case 6994:
		case 7030:
		case 7052:
		case 7221:
		case 7815:
		case 7873:
		case 7985:
		case 8152:
		case 8357:
		case 8375:
		case 8387:
		case 8416:
		case 8437:
		case 8547:
		case 8734:
			strValue = @"BI";
			break;
		case 5650:
		case 5945:
		case 6048:
		case 6677:
		case 6774:
		case 7134:
		case 7614:
		case 7652:
		case 7730:
		case 7760:
		case 8125:
		case 8159:
		case 8289:
		case 8354:
		case 8693:
			strValue = @"BIAN";
			break;
		case 7027:
		case 7084:
		case 7609:
		case 7613:
		case 7958:
		case 7980:
		case 8106:
		case 8149:
		case 8707:
		case 8752:
			strValue = @"BIAO";
			break;
		case 8531:
			strValue = @"BIE";
			break;
		case 5747:
		case 6557:
		case 7145:
		case 7167:
		case 7336:
		case 7375:
		case 7587:
		case 7957:
		case 8738:
		case 8762:
			strValue = @"BIN";
			break;
		case 5787:
		case 5891:
		case 6280:
			strValue = @"BING";
			break;
		case 5781:
		case 6403:
		case 6636:
		case 7362:
		case 7502:
		case 7771:
		case 7864:
		case 8030:
		case 8404:
		case 8543:
		case 8559:
			strValue = @"BO";
			break;
		case 6318:
		case 6945:
		case 7419:
		case 7446:
		case 7848:
		case 7863:
		case 8519:
			strValue = @"BU";
			break;
		case 6474:
		case 7769:
			strValue = @"CA";
			break;
//			strValue = @"CAI";
//			break;
		case 6978:
		case 7078:
		case 7218:
		case 8451:
		case 8785:
			strValue = @"CAN";
			break;
		case 5687:
			strValue = @"CANG";
			break;
		case 6448:
		case 6878:
		case 8309:
		case 8429:
			strValue = @"CAO";
			break;
		case 6692:
			strValue = @"CE";
			break;
		case 6515:
		case 6825:
			strValue = @"CEN";
			break;
		case 6465:
			strValue = @"CENG";
			break;
		case 6639:
		case 6766:
		case 7017:
		case 7230:
		case 7311:
		case 7322:
		case 7363:
		case 7942:
		case 7979:
		case 8135:
			strValue = @"CHA";
			break;
		case 5713:
		case 7846:
		case 8091:
		case 8218:
			strValue = @"CHAI";
			break;
		case 5770:
		case 5838:
		case 6159:
		case 6667:
		case 6893:
		case 6904:
		case 6981:
		case 7031:
		case 7086:
		case 7472:
		case 7688:
		case 7966:
		case 8324:
		case 8580:
			strValue = @"CHAN";
			break;
		case 5686:
		case 5943:
		case 6041:
		case 6137:
		case 6660:
		case 6568:
		case 6749:
		case 7029:
		case 7047:
		case 7438:
		case 7509:
		case 8680:
			strValue = @"CHANG";
			break;
		case 6687:
		case 7443:
		case 8173:
			strValue = @"CHAO";
			break;
		case 5969:
		case 7726:
			strValue = @"CHE";
			break;
		case 5840:
		case 5863:
		case 6251:
		case 6433:
		case 6923:
		case 7201:
		case 7320:
		case 7755:
		case 8619:
			strValue = @"CHEN";
			break;
		case 5609:
		case 5984:
		case 7239:
		case 7263:
		case 7583:
		case 7810:
		case 7881:
		case 7905:
		case 8146:
		case 8241:
		case 8508:
			strValue = @"CHENG";
			break;
		case 5749:
		case 6015:
		case 6061:
		case 6319:
		case 6374:
		case 6420:
		case 6445:
		case 6633:
		case 7042:
		case 7523:
		case 7787:
		case 8023:
		case 8101:
		case 8161:
		case 8231:
		case 8304:
		case 8355:
		case 8388:
		case 8489:
		case 8556:
		case 8746:
			strValue = @"CHI";
			break;
		case 6091:
		case 6671:
		case 6731:
		case 8409:
		case 8430:
			strValue = @"CHONG";
			break;
		case 5717:
		case 6492:
		case 6716:
		case 8112:
		case 8637:
			strValue = @"CHOU";
			break;
		case 5601:
		case 5927:
		case 6680:
		case 6732:
		case 7109:
		case 7238:
		case 7290:
		case 7343:
		case 8150:
		case 8260:
		case 8573:
		case 8777:
			strValue = @"CHU";
			break;
		case 6285:
		case 6408:
		case 7590:
		case 8563:
			strValue = @"CHUAI";
			break;
		case 6622:
		case 6955:
		case 7516:
		case 7843:
		case 8413:
			strValue = @"CHUAN";
			break;
		case 6675:
			strValue = @"CHUANG";
			break;
		case 5879:
		case 7302:
		case 7319:
			strValue = @"CHUI";
			break;
		case 6127:
		case 8040:
		case 8277:
			strValue = @"CHUN";
			break;
		case 7401:
		case 8554:
		case 8626:
			strValue = @"CHUO";
			break;
//			strValue = @"CI";
//			break;
		case 6075:
		case 6358:
		case 7684:
		case 8043:
		case 8457:
			strValue = @"4337 À≈";
			break;
		case 6042:
		case 6840:
		case 7085:
		case 7193:
		case 7214:
		case 7240:
			strValue = @"CONG";
			break;
		case 7308:
		case 7403:
		case 7577:
			strValue = @"COU";
			break;
		case 6180:
		case 6562:
		case 6607:
		case 7367:
		case 8501:
		case 8530:
		case 8577:
			strValue = @"CU";
			break;
		case 5764:
		case 6305:
		case 7664:
		case 7973:
			strValue = @"CUAN";
			break;
		case 6718:
		case 6145:
		case 6393:
		case 7213:
		case 7333:
		case 7505:
		case 8631:
			strValue = @"CUI";
			break;
		case 6666:
		case 8169:
			strValue = @"CUN";
			break;
		case 5640:
		case 6547:
		case 7566:
		case 7917:
		case 7983:
		case 8078:
		case 8526:
		case 8567:
			strValue = @"CUO";
			break;
		case 6239:
		case 6353:
		case 6410:
		case 6682:
		case 7007:
		case 8155:
		case 8346:
		case 8716:
		case 8718:
			strValue = @"DA";
			break;
		case 6004:
		case 6316:
		case 6523:
		case 6942:
		case 7110:
		case 7173:
		case 8776:
			strValue = @"DAI";
			break;
		case 5757:
		case 6144:
		case 6402:
		case 7373:
		case 7470:
		case 7781:
		case 8067:
		case 8087:
		case 8185:
		case 8376:
			strValue = @"DAN";
			break;
		case 5852:
		case 5942:
		case 6148:
		case 6920:
		case 7724:
		case 7885:
		case 8141:
			strValue = @"DANG";
			break;
		case 6322:
		case 6665:
		case 7514:
		case 8478:
			strValue = @"DAO";
			break;
		case 7929:
			strValue = @"DE";
			break;
		case 6466:
		case 6556:
		case 7413:
		case 7767:
		case 7975:
		case 8403:
			strValue = @"DENG";
			break;
		case 5621:
		case 5765:
		case 5814:
		case 5848:
		case 5901:
		case 5970:
		case 6122:
		case 6454:
		case 7023:
		case 7116:
		case 7260:
		case 7306:
		case 7475:
		case 7738:
		case 7758:
		case 7791:
		case 7965:
		case 8438:
		case 8730:
			strValue = @"DI";
			break;
		case 6439:
			strValue = @"DIA";
			break;
		case 5871:
		case 5967:
		case 6559:
		case 7172:
		case 7868:
		case 8116:
		case 8118:
		case 8401:
		case 8558:
			strValue = @"DIAN";
			break;
		case 7886:
		case 8585:
		case 8684:
			strValue = @"DIAO";
			break;
		case 5976:
		case 6006:
		case 6273:
		case 6409:
		case 7526:
		case 8012:
		case 8183:
		case 8562:
		case 8688:
			strValue = @"DIE";
			break;
		case 5674:
		case 6404:
		case 7164:
		case 7575:
		case 7754:
		case 7814:
		case 8059:
		case 8184:
		case 8490:
			strValue = @"DING";
			break;
		case 7891:
			strValue = @"DIU";
			break;
		case 5977:
		case 6343:
		case 6520:
		case 6528:
		case 7517:
		case 7543:
		case 7556:
		case 7747:
		case 8020:
			strValue = @"DONG";
			break;
		case 6190:
		case 8128:
		case 8229:
		case 8391:
			strValue = @"DOU";
			break;
		case 6022:
		case 6429:
		case 6834:
		case 7292:
		case 7525:
		case 8328:
		case 8338:
		case 8739:
		case 8782:
			strValue = @"DU";
			break;
		case 7318:
		case 7649:
		case 8393:
			strValue = @"DUAN";
			break;
		case 7701:
		case 7713:
		case 7752:
			strValue = @"DUI";
			break;
		case 6771:
		case 7632:
		case 7727:
		case 7766:
		case 7779:
		case 7970:
		case 8527:
			strValue = @"DUN";
			break;
		case 6345:
		case 6365:
		case 6785:
		case 7122:
		case 7876:
		case 8154:
		case 8566:
			strValue = @"DUO";
			break;
		case 5612:
		case 5832:
		case 5844:
		case 5949:
		case 6035:
		case 6113:
		case 6164:
		case 6332:
		case 6721:
		case 6977:
		case 7025:
		case 7378:
		case 7581:
		case 7916:
		case 7941:
		case 8042:
		case 8206:
		case 8689:
			strValue = @"E";
			break;
		case 6176:
		case 6284:
			strValue = @"EN";
			break;
		case 5706:
		case 6939:
		case 7177:
		case 7879:
		case 8025:
		case 8660:
			strValue = @"ER";
			break;
		case 5950:
		case 7732:
			strValue = @"FA";
			break;
		case 6212:
		case 6232:
		case 6506:
		case 7283:
		case 7660:
		case 7818:
		case 8576:
			strValue = @"FAN";
			break;
		case 5890:
		case 7242:
		case 7853:
		case 8419:
		case 8648:
			strValue = @"FANG";
			break;
		case 6032:
		case 6584:
		case 6713:
		case 6839:
		case 6990:
		case 7119:
		case 7328:
		case 7572:
		case 7619:
		case 7673:
		case 7948:
		case 8082:
		case 8267:
		case 8385:
		case 8468:
		case 8613:
		case 8678:
			strValue = @"FEI";
			break;
		case 5739:
		case 6915:
		case 7291:
		case 8687:
		case 8787:
			strValue = @"FEN";
			break;
		case 5726:
		case 5926:
		case 6155:
		case 6384:
		case 6767:
		case 7731:
			strValue = @"FENG";
			break;
//			strValue = @"FO";
//			break;
		case 8330:
			strValue = @"FOU";
			break;
		case 5775:
		case 5776:
		case 5914:
		case 6029:
		case 6062:
		case 6119:
		case 6142:
		case 6252:
		case 6327:
		case 6505:
		case 6686:
		case 6870:
		case 6985:
		case 7058:
		case 7066:
		case 7106:
		case 7108:
		case 7285:
		case 7471:
		case 7680:
		case 7741:
		case 7774:
		case 7775:
		case 7823:
		case 7991:
		case 8005:
		case 8222:
		case 8261:
		case 8280:
		case 8283:
		case 8479:
		case 8535:
		case 8538:
		case 8654:
		case 8691:
			strValue = @"FU";
			break;
		case 6246:
		case 7056:
		case 7057:
		case 7424:
		case 7837:
			strValue = @" GA";
			break;
		case 5604:
		case 5875:
		case 5982:
		case 7414:
		case 7464:
			strValue = @"GAI";
			break;
		case 5965:
		case 6053:
		case 6247:
		case 6306:
		case 6779:
		case 6838:
		case 6887:
		case 7104:
		case 7347:
		case 7426:
		case 7723:
		case 8065:
		case 8491:
			strValue = @"GAN";
			break;
		case 7716:
		case 7824:
		case 8364:
			strValue = @"GANG";
			break;
		case 5626:
		case 5830:
		case 5912:
		case 6227:
		case 7141:
		case 7332:
		case 7334:
		case 7429:
		case 7915:
			strValue = @"GAO";
			break;
		case 5610:
		case 5678:
		case 5933:
		case 5957:
		case 6010:
		case 6435:
		case 7092:
		case 7501:
		case 7585:
		case 7749:
		case 7951:
		case 8143:
		case 8220:
		case 8420:
		case 8732:
			strValue = @"GE";
			break;
//			strValue = @"GEI";
//			break;
		case 5608:
		case 6102:
		case 6371:
		case 8462:
			strValue = @"GEN";
			break;
		case 6376:
		case 6657:
		case 7114:
		case 8665:
			strValue = @"GENG";
			break;
		case 7178:
		case 7537:
		case 8228:
		case 8601:
			strValue = @"GONG";
			break;
		case 5694:
		case 5824:
		case 6524:
		case 6960:
		case 7037:
		case 7135:
		case 7259:
		case 7477:
		case 7616:
		case 8349:
		case 8384:
		case 8724:
			strValue = @"GOU";
			break;
		case 5637:
		case 5812:
		case 6152:
		case 6536:
		case 6773:
		case 7284:
		case 7379:
		case 7484:
		case 7486:
		case 7591:
		case 7617:
		case 7813:
		case 7825:
		case 7860:
		case 7932:
		case 8019:
		case 8083:
		case 8233:
		case 8494:
		case 8593:
		case 8681:
		case 8729:
			strValue = @"GU";
			break;
		case 5652:
		case 5820:
		case 6341:
		case 7273:
		case 7550:
		case 8027:
			strValue = @"GUA";
			break;
//			strValue = @"GUAI";
//			break;
		case 5736:
		case 6124:
		case 6272:
		case 6842:
		case 7834:
		case 8057:
		case 8170:
		case 8704:
			strValue = @"GUAN";
			break;
		case 6359:
		case 6578:
		case 7270:
		case 7555:
			strValue = @"GUANG";
			break;
		case 5648:
		case 5659:
		case 6649:
		case 7003:
		case 7277:
		case 7433:
		case 7448:
		case 8007:
		case 8394:
		case 8657:
		case 8712:
			strValue = @"GUI";
			break;
		case 5782:
		case 7121:
		case 7762:
		case 8671:
			strValue = @"GUN";
			break;
		case 5769:
		case 6266:
		case 6335:
		case 6494:
		case 6538:
		case 6603:
		case 7304:
		case 7529:
		case 8188:
		case 8268:
		case 8269:
			strValue = @"GUO";
			break;
		case 7894:
			strValue = @"HA";
			break;
		case 6443:
		case 7560:
		case 8516:
			strValue = @"HAI";
			break;
		case 5885:
		case 6153:
		case 6294:
		case 6759:
		case 6911:
		case 7447:
		case 7642:
		case 8192:
		case 8205:
		case 8232:
		case 8793:
			strValue = @"HAN";
			break;
		case 6776:
		case 7112:
		case 8194:
			strValue = @"HANG";
			break;
		case 6179:
		case 6222:
		case 6438:
		case 6467:
		case 6909:
		case 6916:
		case 7427:
		case 8009:
		case 8211:
		case 8226:
			strValue = @"HAO";
			break;
		case 5813:
		case 5932:
		case 5954:
		case 6432:
		case 6756:
		case 7434:
		case 7833:
		case 8202:
		case 8234:
		case 8471:
			strValue = @"HE";
			break;
//			strValue = @"HEI";
//			break;
//			strValue = @"HEN";
//			break;
		case 6231:
		case 7181:
		case 7276:
			strValue = @"HENG";
			break;
		case 5768:
		case 5774:
		case 5807:
		case 6106:
		case 6214:
		case 6216:
		case 6740:
		case 6792:
			strValue = @"HONG";
			break;
		case 6009:
		case 6565:
		case 6943:
		case 8090:
		case 8383:
		case 8455:
		case 8655:
		case 8731:
			strValue = @"HOU";
			break;
		case 5792:
		case 6392:
		case 6481:
		case 6518:
		case 6609:
		case 6679:
		case 6717:
		case 6816:
		case 6879:
		case 7190:
		case 7346:
		case 7385:
		case 7618:
		case 7635:
		case 7646:
		case 7670:
		case 7672:
		case 7679:
		case 8013:
		case 8032:
		case 8041:
		case 8055:
		case 8343:
		case 8513:
		case 8590:
			strValue = @"HU";
			break;
		case 7072:
		case 7275:
		case 7725:
		case 7892:
			strValue = @"HUA";
			break;
		case 8555:
			strValue = @"HUAI";
			break;
		case 5928:
		case 6140:
		case 6307:
		case 6487:
		case 6621:
		case 6801:
		case 6829:
		case 6881:
		case 6930:
		case 6953:
		case 7157:
		case 7944:
		case 8673:
		case 8763:
			strValue = @"HUAN";
			break;
		case 5882:
		case 6569:
		case 6850:
		case 6874:
		case 6956:
		case 7211:
		case 7533:
		case 8105:
		case 8308:
		case 8382:
		case 8692:
			strValue = @"HUANG";
			break;
		case 5822:
		case 6078:
		case 6086:
		case 6205:
		case 6352:
		case 6360:
		case 6425:
		case 6736:
		case 6807:
		case 6811:
		case 6971:
		case 7132:
		case 7185:
		case 7445:
		case 7703:
		case 8219:
		case 8319:
		case 8766:
			strValue = @"HUI";
			break;
		case 5827:
		case 6638:
		case 6752:
		case 6867:
			strValue = @"HUN";
			break;
		case 5669:
		case 6229:
		case 6311:
		case 6475:
		case 6623:
		case 7856:
		case 7933:
		case 7976:
		case 8175:
		case 8322:
			strValue = @"HUO";
			break;
		case 5629:
		case 5632:
		case 5662:
		case 5705:
		case 5742:
		case 5952:
		case 6024:
		case 6033:
		case 6193:
		case 6210:
		case 6265:
		case 6320:
		case 6350:
		case 6383:
		case 6507:
		case 6553:
		case 6809:
		case 6976:
		case 7087:
		case 7160:
		case 7165:
		case 7314:
		case 7374:
		case 7410:
		case 7411:
		case 7469:
		case 7473:
		case 7487:
		case 7620:
		case 7722:
		case 7831:
		case 7990:
		case 8002:
		case 8104:
		case 8217:
		case 8337:
		case 8339:
		case 8463:
		case 8550:
		case 8611:
		case 8661:
		case 8674:
		case 8757:
		case 8768:
			strValue = @"JI";
			break;
		case 5704:
		case 5903:
		case 6171:
		case 6521:
		case 6804:
		case 6940:
		case 7176:
		case 7409:
		case 7546:
		case 7702:
		case 7882:
		case 7956:
		case 8072:
		case 8142:
		case 8244:
		case 8353:
		case 8434:
		case 8542:
			strValue = @"JIA";
			break;
		case 5752:
		case 5841:
		case 5857:
		case 6149:
		case 6183:
		case 6286:
		case 6853:
		case 6931:
		case 6932:
		case 7144:
		case 7237:
		case 7305:
		case 7407:
		case 7415:
		case 7480:
		case 7489:
		case 7506:
		case 7576:
		case 7790:
		case 7921:
		case 8047:
		case 8148:
		case 8340:
		case 8469:
		case 8534:
		case 8561:
		case 8668:
		case 8721:
			strValue = @"JIAN";
			break;
		case 6092:
		case 6814:
		case 7113:
		case 7154:
		case 7481:
		case 7768:
		case 8180:
		case 8461:
		case 8488:
			strValue = @"JIANG";
			break;
		case 5714:
		case 5753:
		case 6020:
		case 6090:
		case 6256:
		case 6461:
		case 6572:
		case 7015:
		case 7524:
		case 8008:
		case 8052:
		case 8252:
		case 8520:
		case 8551:
		case 8662:
			strValue = @"JIAO";
			break;
		case 5806:
		case 5821:
		case 6255:
		case 6414:
		case 7028:
		case 7061:
		case 7278:
		case 7757:
		case 8060:
		case 8201:
		case 8227:
		case 8441:
		case 8658:
		case 8726:
			strValue = @"JIE";
			break;
		case 5865:
		case 6103:
		case 6132:
		case 6468:
		case 6643:
		case 6659:
		case 7138:
		case 7210:
		case 7340:
		case 7465:
		case 7478:
		case 8138:
			strValue = @"JIN";
			break;
		case 5751:
		case 5869:
		case 6128:
		case 6616:
		case 6729:
		case 6794:
		case 6941:
		case 6982:
		case 7026:
		case 7534:
		case 7554:
		case 7570:
		case 7626:
			strValue = @"JIANG";
			break;
		case 6936:
		case 7671:
			strValue = @"JIONG";
			break;
		case 5754:
		case 6417:
		case 6746:
		case 7249:
		case 7274:
		case 8015:
		case 8053:
		case 8481:
		case 8761:
			strValue = @"JIU";
			break;
		case 5738:
		case 5810:
		case 6036:
		case 6058:
		case 6076:
		case 6268:
		case 6965:
		case 6980:
		case 7202:
		case 7307:
		case 7316:
		case 7323:
		case 7357:
		case 7381:
		case 7488:
		case 7611:
		case 7850:
		case 7924:
		case 8022:
		case 8132:
		case 8153:
		case 8482:
		case 8522:
		case 8565:
		case 8620:
		case 8634:
		case 8722:
			strValue = @"JU";
			break;
		case 5918:
		case 6590:
		case 6824:
		case 7280:
		case 7835:
		case 7935:
		case 7952:
		case 8633:
			strValue = @"JUAN";
			break;
		case 5642:
		case 5667:
		case 5860:
		case 5939:
		case 6207:
		case 6421:
		case 6457:
		case 6469:
		case 6540:
		case 6617:
		case 7062:
		case 7169:
		case 7286:
		case 7351:
		case 7663:
		case 7967:
		case 8574:
		case 8591:
			strValue = @"JUE";
			break;
		case 6260:
		case 8168:
		case 8362:
		case 8769:
			strValue = @"JUN";
			break;
		case 5671:
		case 6339:
		case 7544:
			strValue = @"KA";
			break;
		case 5660:
		case 5978:
		case 6160:
		case 6673:
		case 6693:
		case 7888:
		case 7920:
		case 7939:
			strValue = @"KAI";
			break;
		case 5709:
		case 6108:
		case 7412:
		case 7772:
		case 7811:
			strValue = @"KAN";
			break;
		case 5688:
		case 6742:
		case 7854:
			strValue = @"KANG";
			break;
		case 6974:
		case 7264:
		case 7491:
		case 7877:
			strValue = @"KAO";
			break;
		case 6430:
		case 6519:
		case 6701:
		case 6859:
		case 7076:
		case 7128:
		case 7170:
		case 7380:
		case 7520:
		case 7807:
		case 7861:
		case 7930:
		case 7993:
		case 8066:
		case 8129:
		case 8204:
		case 8282:
		case 8733:
			strValue = @"KE";
			break;
		case 8144:
			strValue = @"KEN";
			break;
		case 7912:
			strValue = @"KENG";
			break;
		case 5737:
		case 6539:
		case 8377:
			strValue = @"KONG";
			break;
		case 6050:
		case 6202:
		case 6321:
		case 7778:
		case 8356:
			strValue = @"KOU";
			break;
		case 5658:
		case 6005:
		case 6423:
		case 7111:
		case 8728:
			strValue = @"KU";
			break;
		case 5708:
			strValue = @"KUA";
			break;
		case 5665:
		case 5906:
		case 6364:
		case 6586:
		case 7558:
			strValue = @"KUAI";
			break;
		case 8737:
			strValue = @"KUAN";
			break;
		case 5818:
		case 5831:
		case 5887:
		case 5959:
		case 6237:
		case 6349:
		case 7094:
		case 7460:
			strValue = @"KUANG";
			break;
		case 5624:
		case 5649:
		case 5771:
		case 6162:
		case 6281:
		case 6413:
		case 6416:
		case 6720:
		case 6951:
		case 7450:
		case 7805:
		case 8606:
		case 8743:
			strValue = @"KUI";
			break;
		case 6204:
		case 6245:
		case 6458:
		case 6618:
		case 6928:
		case 7152:
		case 7841:
		case 8051:
			strValue = @"LIAO";
			break;
		case 5793:
		case 5988:
		case 6270:
		case 6354:
		case 6803:
		case 8483:
		case 8581:
		case 8764:
			strValue = @"LIE";
			break;
		case 6194:
		case 6388:
		case 6555:
		case 6662:
		case 6733:
		case 6964:
		case 7361:
		case 7405:
		case 7602:
		case 7812:
		case 8452:
		case 8579:
		case 8775:
			strValue = @"LIN";
			break;
		case 5925:
		case 6063:
		case 6342:
		case 6482:
		case 6786:
		case 7117:
		case 7258:
		case 7289:
		case 7418:
		case 8186:
		case 8240:
		case 8465:
		case 8676:
			strValue = @"LING";
			break;
		case 6815:
		case 6962:
		case 7082:
		case 7124:
		case 7628:
		case 7654:
		case 7919:
		case 7954:
		case 8050:
		case 8644:
			strValue = @"LIU";
			break;
		case 5966:
		case 6055:
		case 6781:
		case 7171:
		case 7248:
		case 7542:
		case 7735:
		case 8110:
			strValue = @"LONG";
			break;
		case 5745:
		case 6168:
		case 6422:
		case 6548:
		case 7946:
		case 8092:
		case 8179:
		case 8287:
		case 8735:
			strValue = @"LOU";
			break;
		case 6744:
		case 7321:
		case 7586:
		case 7918:
		case 7989:
		case 8158:
			strValue = @"L®π";
			break;
		case 5968:
		case 6303:
		case 6464:
		case 6782:
		case 6843:
		case 6885:
		case 6954:
		case 7220:
		case 7251:
		case 7354:
		case 7391:
		case 7404:
		case 7510:
		case 7545:
		case 7969:
		case 8021:
		case 8056:
		case 8392:
		case 8421:
		case 8652:
			strValue = @"LU";
			break;
		case 5785:
		case 7014:
		case 7279:
		case 8029:
		case 8639:
			strValue = @"LUAN";
			break;
//			strValue = @"L®µE";
//			break;
//			strValue = @"LUN";
//			break;
		case 5732:
		case 5789:
		case 6093:
		case 6259:
		case 6291:
		case 6604:
		case 6788:
		case 6880:
		case 7183:
		case 7301:
		case 7565:
		case 7961:
		case 8107:
		case 8635:
			strValue = @"LUO";
			break;
		case 6328:
			strValue = @"M";
			break;
		case 6373:
		case 6579:
		case 7054:
		case 7231:
		case 8301:
			strValue = @"MA";
			break;
		case 5929:
		case 6104:
		case 8618:
			strValue = @"MAI";
			break;
		case 6012:
		case 6503:
		case 7147:
		case 7655:
		case 7960:
		case 8209:
		case 8293:
		case 8709:
		case 8720:
			strValue = @"MAN";
			break;
		case 5888:
		case 6861:
		case 7743:
		case 8294:
			strValue = @"MANG";
			break;
		case 5783:
		case 6066:
		case 6525:
		case 6787:
		case 7203:
		case 7436:
		case 7483:
		case 7503:
		case 7624:
		case 7714:
		case 7806:
		case 8317:
		case 8754:
			strValue = @"MAO";
			break;
		case 6114:
		case 6550:
		case 6613:
		case 6828:
		case 6856:
		case 7325:
		case 7949:
		case 8044:
		case 8139:
		case 8740:
			strValue = @"MEI";
			break;
		case 6249:
		case 7643:
		case 7715:
		case 7845:
			strValue = @"MEN";
			break;
		case 5934:
		case 6189:
		case 6211:
		case 6734:
		case 7592:
		case 7770:
		case 8221:
		case 8276:
		case 8323:
		case 8427:
		case 8431:
			strValue = @"MENG";
			break;
		case 5634:
		case 5855:
		case 6234:
		case 6368:
		case 6455:
		case 6608:
		case 6772:
		case 6921:
		case 6984:
		case 7563:
		case 7682:
		case 8445:
		case 8767:
		case 8771:
			strValue = @"MI";
			break;
		case 6770:
		case 6837:
		case 6847:
		case 7579:
		case 7777:
			strValue = @"MIAN";
			break;
		case 6387:
		case 6967:
		case 7131:
		case 7149:
		case 7234:
		case 7721:
		case 7780:
		case 8037:
			strValue = @"MIAO";
			break;
		case 5631:
		case 6367:
		case 8326:
		case 8390:
			strValue = @"MIE";
			break;
		case 6069:
		case 6526:
		case 6741:
		case 6793:
		case 7137:
		case 7168:
		case 7175:
		case 7710:
		case 8710:
		case 8628:
			strValue = @"MIN";
			break;
		case 5804:
		case 6088:
		case 6873:
		case 7452:
		case 7808:
		case 8504:
			strValue = @"MING";
			break;
//			strValue = @"MIU";
//			break;
		case 5851:
		case 6052:
		case 6175:
		case 6641:
		case 7038:
		case 7366:
		case 7950:
		case 7987:
		case 8102:
		case 8182:
		case 8586:
		case 8588:
		case 8765:
			strValue = @"MO";
			break;
		case 5716:
		case 6372:
		case 7788:
		case 8254:
		case 8290:
		case 8642:
			strValue = @"MOU";
			break;
		case 5679:
		case 5973:
		case 6057:
		case 6769:
		case 7504:
		case 7866:
			strValue = @"MU";
			break;
		case 6437:
			strValue = @"N";
			break;
		case 6264:
		case 7539:
		case 7953:
		case 8136:
			strValue = @"NA";
			break;
		case 5630:
		case 6021:
		case 6133:
		case 7245:
			strValue = @"NAI";
			break;
		case 6411:
		case 6478:
		case 6479:
		case 7310:
		case 7578:
		case 8279:
		case 8486:
			strValue = @"NAN";
			break;
		case 6313:
		case 6476:
		case 6646:
		case 7457:
			strValue = @"NANG";
			break;
		case 5611:
		case 5981:
		case 6346:
		case 6614:
		case 7207:
		case 7748:
		case 7883:
		case 8245:
			strValue = @"NAO";
			break;
		case 5811:
			strValue = @"NE";
			break;
//			strValue = @"NEI";
//			break;
		case 7705:
			strValue = @"NEN";
			break;
//			strValue = @"NENG";
//			break;
		case 5703:
		case 5972:
		case 6605:
		case 6685:
		case 7439:
		case 7627:
		case 7711:
		case 7794:
		case 7874:
		case 8682:
			strValue = @"NI";
			break;
		case 5605:
		case 5994:
		case 7393:
		case 8004:
		case 8651:
		case 8683:
			strValue = @"NIAN";
			break;
//			strValue = @"NIANG";
//			break;
		case 6064:
		case 7053:
		case 7569:
		case 8433:
			strValue = @"NIAO";
			break;
		case 5877:
		case 6233:
		case 6431:
		case 8208:
		case 8411:
		case 8570:
			strValue = @"NIE";
			break;
//			strValue = @"NIN";
//			break;
		case 5690:
		case 6344:
		case 6924:
		case 8187:
			strValue = @"NING";
			break;
		case 6580:
		case 6678:
		case 7004:
			strValue = @"NIU";
			break;
		case 5715:
		case 6370:
			strValue = @"NONG";
			break;
		case 8181:
			strValue = @"NOU";
			break;
		case 6983:
		case 7032:
		case 7059:
		case 7069:
			strValue = @"NU";
			break;
		case 7704:
		case 7847:
		case 8412:
			strValue = @"N®µ";
			break;
//			strValue = @"NUAN";
//			break;
//			strValue = @"NUE";
//			break;
		case 5748:
		case 6289:
		case 6386:
		case 7927:
			strValue = @"NUO";
			break;
		case 6424:
		case 6462:
			strValue = @"O";
			break;
		case 5809:
		case 6670:
		case 7417:
		case 8178:
			strValue = @"OU";
			break;
		case 6166:
		case 7243:
		case 8365:
			strValue = @"PA";
			break;
		case 5729:
		case 6169:
		case 6363:
			strValue = @"PAI";
			break;
		case 6761:
		case 6790:
		case 8140:
		case 8165:
		case 8320:
		case 8571:
			strValue = @"PAN";
			break;
		case 6561:
		case 6872:
		case 6944:
		case 8306:
			strValue = @"PANG";
			break;
		case 6243:
		case 6583:
		case 6650:
		case 7567:
		case 8069:
			strValue = @"PAO";
			break;
		case 6446:
		case 6490:
		case 7623:
		case 7934:
		case 8512:
		case 8612:
			strValue = @"PEI";
			break;
		case 6852:
			strValue = @"PEN";
			break;
		case 6001:
		case 6456:
		case 6681:
		case 8318:
			strValue = @"PENG";
			break;
		case 5607:
		case 5682:
		case 5880:
		case 5892:
		case 5915:
		case 5960:
		case 6017:
		case 6037:
		case 6308:
		case 6472:
		case 6647:
		case 6836:
		case 7039:
		case 7102:
		case 7233:
		case 7422:
		case 7802:
		case 7828:
		case 7875:
		case 8117:
		case 8166:
		case 8223:
		case 8271:
		case 8589:
			strValue = @"PI";
			break;
		case 5850:
		case 7073:
		case 7490:
		case 7561:
		case 8470:
		case 8568:
			strValue = @"PIAN";
			break;
		case 5666:
		case 6449:
		case 7046:
		case 7146:
		case 7372:
		case 7809:
		case 8310:
			strValue = @"PIAO";
			break;
		case 6054:
		case 7513:
			strValue = @"PIE";
			break;
		case 7041:
		case 6253:
		case 7016:
		case 7315:
		case 7482:
		case 8213:
			strValue = @"PIN";
			break;
		case 5723:
		case 7019:
		case 7250:
		case 8650:
			strValue = @"PING";
			break;
		case 5647:
		case 5922:
		case 7174:
		case 7839:
		case 7862:
		case 8011:
		case 8345:
			strValue = @"PO";
			break;
		case 5786:
		case 6269:
			strValue = @"POU";
			break;
		case 5773:
		case 6459:
		case 6863:
		case 6907:
		case 7217:
		case 7511:
		case 7968:
		case 7972:
		case 8575:
			strValue = @"PU";
			break;
		case 5633:
		case 5725:
		case 5963:
		case 6027:
		case 6046:
		case 6089:
		case 6129:
		case 6134:
		case 6161:
		case 6213:
		case 6366:
		case 6450:
		case 6508:
		case 6510:
		case 6764:
		case 6831:
		case 7075:
		case 7118:
		case 7187:
		case 7189:
		case 7229:
		case 7271:
		case 7342:
		case 7440:
		case 7605:
		case 7687:
		case 7712:
		case 7751:
		case 8193:
		case 8251:
		case 8264:
		case 8475:
		case 8476:
		case 8572:
		case 8702:
		case 8772:
			strValue = @"QI";
			break;
		case 6154:
		case 8736:
			strValue = @"QIA";
			break;
		case 5727:
		case 5761:
		case 5868:
		case 6023:
		case 6045:
		case 6071:
		case 6271:
		case 6509:
		case 6705:
		case 6727:
		case 6925:
		case 6926:
		case 6929:
		case 7155:
		case 7293:
		case 7541:
		case 7709:
		case 7852:
		case 8215:
		case 8373:
			strValue = @"QIAN";
			break;
		case 6762:
		case 7045:
		case 7341:
		case 7408:
		case 7633:
		case 7926:
		case 7947:
		case 7974:
		case 8163:
		case 8262:
		case 8439:
		case 8536:
			strValue = @"QIANG";
			break;
		case 5668:
		case 5829:
		case 5859:
		case 6081:
		case 6529:
		case 6724:
		case 6730:
		case 7352:
		case 7745:
		case 8546:
		case 8719:
			strValue = @"QIAO";
			break;
		case 5907:
		case 6711:
		case 7010:
		case 7492:
		case 7938:
		case 8370:
			strValue = @"QIE";
			break;
		case 6043:
		case 6276:
		case 6336:
		case 6426:
		case 6463:
		case 6858:
		case 7353:
		case 7923:
		case 8291:
		case 8432:
			strValue = @"QIN";
			break;
		case 6060:
		case 6485:
		case 7349:
		case 7764:
		case 8263:
		case 8332:
		case 8368:
		case 8605:
		case 8675:
		case 8784:
			strValue = @"QING";
			break;
		case 5886:
		case 6068:
		case 8123:
		case 8243:
		case 8344:
		case 8528:
		case 8638:
			strValue = @"QIONG";
			break;
		case 5720:
		case 5947:
		case 6576:
		case 6848:
		case 6947:
		case 6957:
		case 7317:
		case 7468:
		case 8216:
		case 8239:
		case 8288:
		case 8435:
		case 8460:
		case 8690:
		case 8792:
			strValue = @"QIU";
			break;
		case 5816:
		case 5930:
		case 6201:
		case 6230:
		case 6511:
		case 6573:
		case 6754:
		case 7219:
		case 7479:
		case 7512:
		case 7552:
		case 7678:
		case 7765:
		case 8119:
		case 8248:
		case 8329:
		case 8480:
		case 8636:
		case 8781:
			strValue = @"QU";
			break;
		case 5825:
		case 6085:
		case 6710:
		case 7125:
		case 7390:
		case 7816:
		case 7893:
		case 8273:
		case 8360:
		case 8760:
			strValue = @"QUAN";
			break;
		case 6755:
		case 6758:
		case 7708:
			strValue = @"QUE";
			break;
		case 6950:
			strValue = @"QUN";
			break;
		case 6059:
		case 8237:
		case 8755:
			strValue = @"RAN";
			break;
		case 7692:
		case 8006:
			strValue = @"RANG";
			break;
		case 6073:
		case 7012:
		case 7267:
			strValue = @"RAO";
			break;
//			strValue = @"RE";
//			break;
		case 5680:
		case 6083:
		case 6156:
		case 6631:
		case 7377:
		case 7994:
		case 8137:
			strValue = @"REN";
			break;
//			strValue = @"RENG";
//			break;
//			strValue = @"RI";
//			break;
		case 6541:
		case 6585:
		case 7337:
		case 7532:
		case 8278:
			strValue = @"RONG";
			break;
		case 8459:
		case 8569:
		case 8723:
			strValue = @"ROU";
			break;
		case 6174:
		case 6224:
		case 6473:
		case 6818:
		case 6865:
		case 6906:
		case 7140:
		case 7908:
		case 8164:
		case 8212:
			strValue = @"RU";
			break;
		case 7535:
			strValue = @"RUAN";
			break;
		case 6039:
		case 6208:
		case 7236:
		case 7803:
		case 8224:
			strValue = @"RUI";
			break;
//			strValue = @"RUN";
//			break;
		case 5728:
		case 8372:
			strValue = @"RUO";
			break;
		case 5606:
		case 5677:
		case 7493:
		case 7559:
		case 7610:
			strValue = @"SA";
			break;
		case 6471:
			strValue = @"SAI";
			break;
		case 6644:
		case 7507:
		case 8454:
			strValue = @"SAN";
			break;
		case 6290:
		case 7763:
		case 8210:
			strValue = @"SANG";
			break;
		case 6003:
		case 7150:
		case 7156:
		case 7593:
		case 8094:
		case 8694:
			strValue = @"SAO";
			break;
//			strValue = @"SE";
//			break;
//			strValue = @"SEN";
//			break;
//			strValue = @"SENG";
//			break;
		case 6394:
		case 7606:
		case 7901:
		case 8080:
		case 8436:
		case 8614:
		case 8672:
			strValue = @"SHA";
			break;
		case 8507:
			strValue = @"SHAI";
			break;
		case 5663:
		case 5808:
		case 5923:
		case 5979:
		case 6047:
		case 6890:
		case 7009:
		case 7051:
		case 7083:
		case 7594:
		case 7844:
		case 8062:
		case 8321:
		case 8414:
		case 8539:
		case 8713:
			strValue = @"SHAN";
			break;
		case 5980:
		case 7120:
		case 7368:
		case 7656:
		case 8592:
			strValue = @"SHANG";
			break;
		case 5931:
		case 6070:
		case 6891:
		case 7228:
		case 8366:
		case 8425:
			strValue = @"SHAO";
			break;
		case 5639:
		case 5760:
		case 6606:
		case 6860:
		case 7608:
		case 7820:
		case 8774:
			strValue = @"SHE";
			break;
		case 5837:
		case 6123:
		case 6351:
		case 6841:
		case 7309:
		case 7547:
		case 7982:
		case 8255:
			strValue = @"SHEN";
			break;
		case 6551:
		case 7441:
		case 7782:
		case 8347:
			strValue = @"SHENG";
			break;
		case 5854:
		case 5985:
		case 6110:
		case 6173:
		case 6317:
		case 7388:
		case 7459:
		case 7634:
		case 7870:
		case 8307:
		case 8334:
		case 8363:
		case 8525:
		case 8669:
		case 8685:
			strValue = @"SHI";
			break;
		case 6587:
		case 7123:
		case 8428:
			strValue = @"SHOU";
			break;
		case 5731:
		case 5951:
		case 6136:
		case 6283:
		case 6780:
		case 6888:
		case 7013:
		case 7508:
		case 7582:
		case 7988:
			strValue = @"SHU";
			break;
		case 6407:
			strValue = @"SHUA";
			break;
		case 8316:
			strValue = @"SHUAI";
			break;
		case 6737:
		case 6844:
			strValue = @"SHUAN";
			break;
		case 7055:
			strValue = @"SHUANG";
			break;
//			strValue = @"SHUI";
//			break;
//			strValue = @"SHUN";
//			break;
		case 6184:
		case 6287:
		case 6989:
		case 7335:
		case 7869:
			strValue = @"SHUO";
			break;
		case 5643:
		case 5778:
		case 5944:
		case 6348:
		case 6765:
		case 6784:
		case 6889:
		case 7006:
		case 7065:
		case 7133:
		case 7675:
		case 7940:
		case 8024:
		case 8174:
		case 8247:
		case 8351:
			strValue = @"SI";
			break;
		case 5801:
		case 6131:
		case 6534:
		case 6552:
		case 6676:
		case 6704:
		case 6833:
		case 8121:
			strValue = @"SONG";
			break;
		case 5937:
		case 6220:
		case 6418:
		case 6453:
		case 6640:
		case 6849:
		case 7612:
		case 7804:
		case 7943:
		case 8284:
			strValue = @"SOU";
			break;
		case 5777:
		case 5853:
		case 6188:
		case 6428:
		case 6726:
		case 6819:
		case 8389:
		case 8602:
		case 8653:
			strValue = @"SU";
			break;
		case 6601:
			strValue = @"SUAN";
			break;
		case 5839:
		case 6120:
		case 6901:
		case 6968:
		case 7661:
		case 7785:
		case 7801:
			strValue = @"SUI";
			break;
		case 6105:
		case 6588:
		case 6624:
		case 7330:
		case 8632:
			strValue = @"SUN";
			break;
		case 6379:
		case 6434:
		case 6442:
		case 7022:
		case 7288:
		case 7792:
		case 8440:
			strValue = @"SUO";
			break;
		case 6743:
		case 6866:
		case 6961:
		case 7329:
		case 7719:
		case 7872:
		case 8533:
		case 8703:
			strValue = @"TA";
			break;
		case 5902:
		case 6223:
		case 6330:
		case 7070:
		case 7536:
		case 7638:
		case 7849:
		case 8544:
		case 8656:
			strValue = @"TAI";
			break;
		case 5916:
		case 6903:
		case 7428:
		case 7694:
		case 7867:
		case 7936:
		case 8191:
			strValue = @"TAN";
			break;
		case 5746:
		case 6491:
		case 6871:
		case 7209:
		case 7344:
		case 7906:
		case 7959:
		case 8177:
		case 8305:
		case 8311:
		case 8442:
		case 8517:
			strValue = @"TANG";
			break;
		case 5627:
		case 6391:
		case 6812:
		case 7226:
		case 7666:
			strValue = @"TAO";
			break;
//			strValue = @"1845 ≤Õ";
//			break;
		case 6315:
		case 7693:
		case 7911:
			strValue = @"TE";
			break;
		case 7588:
			strValue = @"TENG";
			break;
		case 5735:
		case 6709:
		case 6949:
		case 7130:
		case 8035:
		case 8151:
		case 8514:
			strValue = @"TI";
			break;
		case 6261:
		case 6735:
		case 6757:
		case 7369:
		case 7817:
			strValue = @"TIAN";
			break;
		case 5712:
		case 7686:
		case 8127:
		case 8272:
		case 8352:
		case 8448:
		case 8622:
		case 8670:
		case 8756:
			strValue = @"TIAO";
			break;
		case 6138:
		case 8749:
			strValue = @"TIE";
			break;
		case 6080:
		case 6167:
		case 7035:
		case 7272:
		case 7890:
		case 8249:
		case 8610:
			strValue = @"TING";
			break;
		case 5701:
		case 5758:
		case 6077:
		case 6444:
		case 6690:
		case 6892:
		case 7737:
			strValue = @"TONG";
			break;
		case 7855:
		case 7822:
		case 8727:
			strValue = @"TOU";
			break;
		case 6002:
		case 6117:
		case 6143:
		case 7842:
		case 8509:
			strValue = @"TU";
			break;
		case 6250:
		case 6972:
			strValue = @"TUAN";
			break;
		case 7653:
			strValue = @"TUI";
			break;
		case 5759:
		case 6629:
		case 7453:
		case 7564:
			strValue = @"TUN";
			break;
		case 5617:
		case 5702:
		case 5971:
		case 6653:
		case 6791:
		case 7256:
		case 7262:
		case 7350:
		case 7740:
		case 8374:
		case 8502:
		case 8541:
		case 8630:
			strValue = @"TUO";
			break;
		case 5684:
		case 7020:
		case 7580:
			strValue = @"WA";
			break;
//			strValue = @"WAI";
//			break;
		case 5664:
		case 6025:
		case 6150:
		case 7093:
		case 7126:
		case 7194:
		case 7568:
		case 7821:
		case 8274:
			strValue = @"WAN";
			break;
		case 5672:
		case 6244:
		case 6715:
		case 7394:
		case 8745:
			strValue = @"WANG";
			break;
		case 5743:
		case 5835:
		case 5881:
		case 5883:
		case 6158:
		case 6217:
		case 6488:
		case 6501:
		case 6543:
		case 6545:
		case 6611:
		case 6612:
		case 6739:
		case 6777:
		case 6802:
		case 6822:
		case 6952:
		case 7024:
		case 7166:
		case 7224:
		case 7406:
		case 7631:
		case 7648:
		case 8084:
		case 8426:
		case 8659:
			strValue = @"WEI";
			break;
		case 5656:
		case 6751:
		case 6775:
		case 7223:
		case 8609:
			strValue = @"WEN";
			break;
		case 6178:
		case 6219:
			strValue = @"WENG";
			break;
		case 5733:
		case 6111:
		case 6502:
		case 6855:
		case 7531:
		case 7750:
		case 8627:
			strValue = @"WO";
			break;
		case 5603:
		case 5685:
		case 5867:
		case 5889:
		case 5956:
		case 6044:
		case 6377:
		case 6648:
		case 6668:
		case 6672:
		case 6820:
		case 6927:
		case 6935:
		case 6992:
		case 7036:
		case 7080:
		case 7227:
		case 7485:
		case 7641:
		case 8036:
		case 8045:
		case 8077:
		case 8258:
		case 8640:
		case 8789:
			strValue = @"WU";
			break;
		case 5750:
		case 5766:
		case 5884:
		case 5913:
		case 6130:
		case 6163:
		case 6191:
		case 6241:
		case 6381:
		case 6567:
		case 6630:
		case 6750:
		case 6827:
		case 6832:
		case 6979:
		case 7050:
		case 7184:
		case 7356:
		case 7456:
		case 7474:
		case 7604:
		case 7668:
		case 7689:
		case 7691:
		case 8010:
		case 8122:
		case 8265:
		case 8303:
		case 8312:
		case 8410:
		case 8424:
		case 8443:
		case 8449:
		case 8466:
		case 8521:
		case 8791:
			strValue = @"XI";
			break;
		case 6340:
		case 6582:
		case 6958:
		case 7206:
		case 7252:
		case 7744:
		case 8093:
		case 8333:
		case 8779:
			strValue = @"XIA";
			break;
		case 5794:
		case 5823:
		case 6040:
		case 6118:
		case 6226:
		case 6513:
		case 6593:
		case 6963:
		case 7021:
		case 7515:
		case 7662:
		case 7676:
		case 8034:
		case 8079:
		case 8225:
		case 8358:
		case 8444:
		case 8503:
		case 8548:
		case 8549:
		case 8617:
			strValue = @"XIAN";
			break;
		case 6028:
		case 6157:
		case 6635:
		case 6652:
		case 7088:
		case 7129:
		case 8313:
		case 8663:
		case 8747:
			strValue = @"XIANG";
			break;
		case 6356:
		case 6537:
		case 6876:
		case 6948:
		case 7071:
		case 7115:
		case 7241:
		case 7253:
		case 8257:
		case 8367:
		case 8379:
		case 8744:
			strValue = @"XIAO";
			break;
		case 5741:
		case 5784:
		case 5936:
		case 5938:
		case 6215:
		case 6302:
		case 6619:
		case 6661:
		case 6845:
		case 6912:
		case 6966:
		case 7105:
		case 7151:
		case 7331:
		case 7339:
		case 8583:
			strValue = @"XIE";
			break;
		case 5622:
		case 6016:
		case 7431:
		case 7607:
		case 8646:
			strValue = @"XIN";
			break;
		case 5874:
		case 6084:
		case 6309:
		case 6712:
		case 7742:
			strValue = @"XING";
			break;
		case 6026:
			strValue = @"XIONG";
			break;
		case 6361:
		case 6522:
		case 6642:
		case 6651:
		case 6869:
		case 8028:
		case 8587:
		case 8759:
			strValue = @"XIU";
			break;
		case 5828:
		case 5935:
		case 5955:
		case 6203:
		case 6810:
		case 6851:
		case 7179:
		case 7282:
		case 7667:
		case 7776:
		case 8167:
		case 8458:
		case 8515:
			strValue = @"XU";
			break;
		case 5756:
		case 5846:
		case 6170:
		case 6279:
		case 6789:
		case 6854:
		case 6886:
		case 7215:
		case 7324:
		case 7449:
		case 7637:
		case 7651:
		case 7759:
		case 7871:
		case 7964:
		case 8071:
			strValue = @"XUAN";
			break;
		case 5842:
		case 7720:
		case 8529:
		case 8708:
			strValue = @"XUE";
			break;
		case 5767:
		case 5908:
		case 5987:
		case 6087:
		case 6101:
		case 6206:
		case 6225:
		case 6530:
		case 6563:
		case 6620:
		case 6694:
		case 6813:
		case 6817:
		case 7454:
		case 8131:
		case 8524:
		case 8664:
			strValue = @"XUN";
			break;
		case 5683:
		case 5975:
		case 6275:
		case 6512:
		case 6934:
		case 7011:
		case 7180:
		case 7266:
		case 7518:
		case 7728:
		case 7793:
		case 8073:
			strValue = @"YA";
			break;
		case 5641:
		case 5645:
		case 5718:
		case 5740:
		case 5780:
		case 5861:
		case 5917:
		case 5919:
		case 6030:
		case 6146:
		case 6535:
		case 6691:
		case 6738:
		case 6753:
		case 6846:
		case 6857:
		case 6991:
		case 7044:
		case 7192:
		case 7360:
		case 7444:
		case 7557:
		case 7645:
		case 7827:
		case 8359:
		case 8506:
		case 8742:
		case 8748:
		case 8790:
			strValue = @"YAN";
			break;
		case 6564:
		case 6683:
		case 7630:
		case 7640:
		case 7706:
		case 8253:
		case 8717:
			strValue = @"YANG";
			break;
		case 5618:
		case 5619:
		case 6326:
		case 6542:
		case 6570:
		case 7159:
		case 7182:
		case 7235:
		case 7387:
		case 7455:
		case 7540:
		case 7902:
		case 8046:
		case 8126:
		case 8477:
		case 8705:
			strValue = @"YAO";
			break;
		case 5644:
		case 5843:
		case 5894:
		case 6262:
		case 7442:
		case 7639:
		case 7884:
			strValue = @"YE";
			break;
		case 5655:
		case 5657:
		case 5670:
		case 5693:
		case 5711:
		case 5817:
		case 5961:
		case 5992:
		case 6018:
		case 6051:
		case 6072:
		case 6218:
		case 6236:
		case 6240:
		case 6258:
		case 6314:
		case 6329:
		case 6355:
		case 6362:
		case 6441:
		case 6470:
		case 6527:
		case 6558:
		case 6602:
		case 6634:
		case 6688:
		case 6689:
		case 6708:
		case 6884:
		case 6938:
		case 7068:
		case 7143:
		case 7376:
		case 7383:
		case 7461:
		case 7629:
		case 7658:
		case 7784:
		case 7838:
		case 7955:
		case 7978:
		case 8074:
		case 8089:
		case 8115:
		case 8120:
		case 8270:
		case 8415:
		case 8464:
		case 8472:
		case 8493:
		case 8780:
			strValue = @"YI";
			break;
		case 5623:
		case 5920:
		case 5983:
		case 6007:
		case 6065:
		case 6337:
		case 6419:
		case 6594:
		case 6625:
		case 6806:
		case 7519:
		case 7887:
		case 8111:
		case 8230:
		case 8615:
		case 8624:
			strValue = @"YIN";
			break;
		case 5788:
		case 5911:
		case 6067:
		case 6094:
		case 6126:
		case 6151:
		case 6186:
		case 6292:
		case 6451:
		case 6663:
		case 6862:
		case 6875:
		case 6913:
		case 7188:
		case 7212:
		case 7326:
		case 7584:
		case 8048:
		case 8108:
		case 8203:
		case 8331:
			strValue = @"YING";
			break;
		case 6401:
			strValue = @"YO";
			break;
		case 5724:
		case 5953:
		case 6013:
		case 6415:
		case 6728:
		case 7163:
		case 7962:
		case 8014:
		case 8711:
		case 8751:
			strValue = @"YONG";
			break;
		case 5653:
		case 5692:
		case 5707:
		case 6112:
		case 6115:
		case 6121:
		case 6347:
		case 6483:
		case 6922:
		case 7254:
		case 7364:
		case 7527:
		case 7880:
		case 8064:
		case 8236:
		case 8242:
		case 8286:
		case 8647:
		case 8778:
		case 8788:
			strValue = @"YOU";
			break;
		case 5614:
		case 5625:
		case 5681:
		case 5722:
		case 5836:
		case 5845:
		case 6139:
		case 6187:
		case 6277:
		case 6484:
		case 6486:
		case 6546:
		case 6592:
		case 6632:
		case 6637:
		case 6655:
		case 6748:
		case 6987:
		case 6993:
		case 7005:
		case 7090:
		case 7204:
		case 7437:
		case 7476:
		case 7573:
		case 7603:
		case 7622:
		case 7647:
		case 7659:
		case 7718:
		case 7858:
		case 8033:
		case 8054:
		case 8085:
		case 8086:
		case 8130:
		case 8133:
		case 8266:
		case 8285:
		case 8336:
		case 8407:
		case 8408:
		case 8607:
		case 8625:
			strValue = @"YU";
			break;
		case 5989:
		case 6011:
		case 6282:
		case 6768:
		case 7034:
		case 7205:
		case 7358:
		case 7528:
		case 7783:
		case 8016:
		case 8302:
		case 8378:
		case 8629:
			strValue = @"YUAN";
			break;
		case 5763:
		case 6914:
		case 7348:
		case 7530:
		case 7865:
			strValue = @"YUE";
			break;
		case 5909:
		case 6031:
		case 6581:
		case 6702:
		case 6719:
		case 7101:
		case 7225:
		case 7370:
		case 7432:
		case 7521:
		case 7657:
			strValue = @"YUN";
			break;
		case 6257:
		case 6338:
			strValue = @"ZA";
			break;
		case 6544:
		case 7162:
			strValue = @"ZAI";
			break;
		case 7222:
		case 7435:
		case 8402:
		case 8456:
		case 8485:
		case 8641:
			strValue = @"ZAN";
			break;
		case 6242:
		case 7064:
		case 7416:
			strValue = @"ZANG";
			break;
		case 6380:
			strValue = @"ZAO";
			break;
		case 5638:
		case 8369:
		case 5651:
		case 6385:
		case 6493:
		case 6937:
		case 7430:
		case 8348:
		case 8423:
			strValue = @"ZE";
			break;
//			strValue = @"ZEI";
//			break;
		case 5858:
			strValue = @"ZEN";
			break;
		case 7153:
		case 7421:
		case 7832:
		case 7913:
			strValue = @"ZENG";
			break;
		case 6610:
		case 6274:
		case 6324:
		case 6369:
		case 6378:
		case 7736:
		case 8068:
		case 8238:
		case 8794:
			strValue = @"ZHA";
			break;
		case 7746:
		case 8109:
			strValue = @"ZHAI";
			break;
		case 5862:
		case 6288:
		case 7625:
			strValue = @"ZHAN";
			break;
		case 5675:
		case 5921:
		case 6504:
		case 6554:
		case 6615:
		case 7049:
		case 7216:
		case 8315:
			strValue = @"ZHANG";
			break;
		case 5815:
		case 7294:
		case 7840:
		case 8341:
			strValue = @"ZHAO";
			break;
		case 5856:
		case 6301:
		case 7247:
		case 7392:
		case 7761:
		case 8049:
		case 8162:
		case 8256:
		case 8487:
			strValue = @"ZHE";
			break;
		case 5958:
		case 6172:
		case 6805:
		case 7139:
		case 7269:
		case 7327:
		case 7384:
		case 7466:
		case 7551:
		case 7562:
		case 7685:
		case 7819:
		case 8001:
		case 8018:
		case 8380:
			strValue = @"ZHEN";
			break;
		case 5826:
		case 6531:
		case 6571:
		case 7859:
		case 7903:
		case 8361:
			strValue = @"ZHENG";
			break;
		case 5620:
		case 5876:
		case 5904:
		case 5990:
		case 6038:
		case 6293:
		case 6489:
		case 6669:
		case 6973:
		case 6975:
		case 7079:
		case 7246:
		case 7255:
		case 7257:
		case 7268:
		case 7382:
		case 7389:
		case 7462:
		case 7553:
		case 7589:
		case 7677:
		case 7683:
		case 7773:
		case 7984:
		case 8026:
		case 8075:
		case 8246:
		case 8474:
		case 8505:
		case 8537:
		case 8557:
		case 8560:
		case 8584:
		case 8603:
			strValue = @"ZHI";
			break;
		case 5803:
		case 7981:
		case 8314:
		case 8417:
		case 8564:
			strValue = @"ZHONG";
			break;
		case 6107:
		case 6390:
		case 7008:
		case 7091:
		case 7107:
		case 7548:
		case 7756:
		case 8406:
		case 8492:
			strValue = @"ZHOU";
			break;
		case 5689:
		case 5710:
		case 5905:
		case 6049:
		case 6079:
		case 6808:
		case 6830:
		case 6883:
		case 7244:
		case 7338:
		case 7345:
		case 7636:
		case 7889:
		case 8070:
		case 8081:
		case 8335:
		case 8371:
		case 8422:
		case 8467:
		case 8578:
		case 8770:
			strValue = @"ZHU";
			break;
//			strValue = @"ZHUA";
//			break;
//			strValue = @"ZHUAI";
//			break;
		case 6389:
		case 6645:
		case 8207:
			strValue = @"ZHUAN";
			break;
		case 5755:
			strValue = @"ZHUANG";
			break;
		case 6723:
		case 7077:
		case 7136:
			strValue = @"ZHUI";
			break;
		case 7538:
		case 8124:
			strValue = @"ZHUN";
			break;
		case 5730:
		case 5834:
		case 6310:
		case 6823:
		case 6835:
		case 6910:
		case 7644:
		case 7690:
		case 7729:
		case 7977:
			strValue = @"ZHUO";
			break;
		case 5849:
		case 6549:
		case 7002:
		case 7060:
		case 7127:
		case 7287:
		case 7402:
		case 7463:
		case 7707:
		case 7786:
		case 7937:
		case 7986:
		case 8172:
		case 8342:
		case 8450:
		case 8484:
		case 8594:
		case 8604:
		case 8623:
		case 8686:
		case 8758:
			strValue = @"ZI";
			break;
		case 5744:
		case 7574:
		case 8453:
			strValue = @"ZONG";
			break;
		case 5833:
		case 5878:
		case 5924:
		case 7067:
		case 8677:
			strValue = @"ZOU";
			break;
		case 5762:
		case 6147:
		case 7963:
			strValue = @"ZU";
			break;
		case 6312:
		case 7158:
		case 8582:
			strValue = @"ZUAN";
			break;
		case 6209:
			strValue = @"ZUI";
			break;
		case 6304:
		case 7355:
		case 8714:
			strValue = @"ZUN";
			break;
		case 5872:
		case 6382:
		case 6460:
		case 6684:
		case 7549:
		case 7681:
			strValue = @"ZUO";
			break;
		default:
			if(nCode >= 1601 && nCode <= 1602)
			{
				strValue = @"A";
				break;
			}
			if(nCode >= 1603 && nCode <= 1615)
			{
				strValue = @"AI";
				break;
			}
			if(nCode >= 1616 && nCode <= 1624)
			{
				strValue = @"AN";
				break;
			}
			if(nCode >= 1625 && nCode <= 1627)
			{
				strValue = @"ANG";
				break;
			}
			if(nCode >= 1628 && nCode <= 1636)
			{
				strValue = @"AO";
				break;
			}
			if(nCode >= 1637 && nCode <= 1654)
			{
				strValue = @"BA";
				break;
			}
			if(nCode >= 1655 && nCode <= 1662)
			{
				strValue = @"BAI";
				break;
			}
			if(nCode >= 1663 && nCode <= 1677)
			{
				strValue = @"BAN";
				break;
			}
			if(nCode >= 1678 && nCode <= 1689)
			{
				strValue = @"BANG";
				break;
			}
			if(nCode >= 1690 && nCode <= 1712)
			{
				strValue = @"BAO";
				break;
			}
			if(nCode >= 1713 && nCode <= 1727)
			{
				strValue = @"BEI";
				break;
			}
			if(nCode >= 1728 && nCode <= 1731)
			{
				strValue = @"BEN";
				break;
			}
			if(nCode >= 1732 && nCode <= 1737)
			{
				strValue = @"BENG";
				break;
			}
			if(nCode>1738 && nCode <= 1761)
			{
				strValue = @"BI";
				break;
			}
			if(nCode >= 1762 && nCode <= 1773)
			{
				strValue = @"BIAN";
				break;
			}
			if(nCode >= 1774 && nCode <= 1777)
			{
				strValue = @"BIAO";
				break;
			}
			if(nCode >= 1778 && nCode <= 1781)
			{
				strValue = @"BIE";
				break;
			}
			if(nCode >= 1782 && nCode <= 1787)
			{
				strValue = @"BIN";
				break;
			}
			if(nCode >= 1788 && nCode <= 1794)
			{
				strValue = @"BING";
				break;
			}
			if(nCode >= 1801 && nCode <= 1802)
			{
				strValue = @"BING";
				break;
			}
			if(nCode >= 1803 && nCode <= 1821)
			{
				strValue = @"BO";
				break;
			}
			if(nCode >= 1822 && nCode <= 1832)
			{
				strValue = @"BU";
				break;
			}
			if(nCode==1833)
			{
				strValue = @"CA";
				break;
			}
			if(nCode >= 1834 && nCode <= 1844)
			{
				strValue = @"CAI";
				break;
			}
			if(nCode >= 1845 && nCode <= 1851)
			{
				strValue = @"CAN";
				break;
			}
			if(nCode >= 1852 && nCode <= 1856)
			{
				strValue = @"CANG";
				break;
			}
			if(nCode >= 1857 && nCode <= 1861)
			{
				strValue = @"CAO";
				break;
			}
			if(nCode >= 1862 && nCode <= 1866)
			{
				strValue = @"CE";
				break;
			}
			if(nCode >= 1867 && nCode <= 1868)
			{
				strValue = @"CENG";
				break;
			}
			if(nCode >= 1869 && nCode <= 1879)
			{
				strValue = @"CHA";
				break;
			}
			if(nCode >= 1880 && nCode <= 1882)
			{
				strValue = @"CHAI";
				break;
			}
			if(nCode >= 1883 && nCode <= 1892)
			{
				strValue = @"CHAN";
				break;
			}
			if(nCode >= 1893 && nCode <= 1911)
			{
				strValue = @"CHANG";
				break;
			}
			if(nCode >= 1912 && nCode <= 1920)
			{
				strValue = @"CHAO";
				break;
			}
			if(nCode >= 1921 && nCode <= 1926)
			{
				strValue = @"CHE";
				break;
			}
			if(nCode >= 1927 && nCode <= 1936)
			{
				strValue = @"CHEN";
				break;
			}
			if(nCode >= 1937 && nCode <= 1951)
			{
				strValue = @"CHENG";
				break;
			}
			if(nCode >= 1952 && nCode <= 1967)
			{
				strValue = @"CHI";
				break;
			}
			if(nCode >= 1968 && nCode <= 1972)
			{
				strValue = @"CHONG";
				break;
			}
			if(nCode >= 1973 && nCode <= 1984)
			{
				strValue = @"CHOU";
				break;
			}
			if(nCode >= 1985 && nCode <= 2006)
			{
				strValue = @"CHU";
				break;
			}
			if(nCode==2007)
			{
				strValue = @"CHUAI";
				break;
			}
			if(nCode >= 2008 && nCode <= 2014)
			{
				strValue = @"CHUAN";
				break;
			}
			if(nCode >= 2015 && nCode <= 2020)
			{
				strValue = @"CHUANG";
				break;
			}
			if(nCode >= 2021 && nCode <= 2025)
			{
				strValue = @"CHUI";
				break;
			}
			if(nCode >= 2026 && nCode <= 2032)
			{
				strValue = @"CHUN";
				break;
			}
			if(nCode >= 2033 && nCode <= 2034)
			{
				strValue = @"CHUO";
				break;
			}
			if(nCode >= 2035 && nCode <= 2046)
			{
				strValue = @"CI";
				break;
			}
			if(nCode >= 2047 && nCode <= 2052)
			{
				strValue = @"CONG";
				break;
			}
			if(nCode >= 2054 && nCode <= 2057)
			{
				strValue = @"CU";
				break;
			}
			if(nCode >= 2058 && nCode <= 2060)
			{
				strValue = @"CUAN";
				break;
			}
			if(nCode >= 2061 && nCode <= 2068)
			{
				strValue = @"CUI";
				break;
			}
			if(nCode >= 2069 && nCode <= 2071)
			{
				strValue = @"CUN";
				break;
			}
			if(nCode >= 2072 && nCode <= 2077)
			{
				strValue = @"CUO";
				break;
			}
			if(nCode >= 2078 && nCode <= 2083)
			{
				strValue = @"DA";
				break;
			}
			if(nCode >= 2084 && nCode <= 2094)
			{
				strValue = @"DAI";
				break;
			}
			if(nCode >= 2102 && nCode <= 2116)
			{
				strValue = @"DAN";
				break;
			}
			if(nCode >= 2117 && nCode <= 2121)
			{
				strValue = @"DANG";
				break;
			}
			if(nCode >= 2122 && nCode <= 2133)
			{
				strValue = @"DAO";
				break;
			}
			if(nCode >= 2134 && nCode <= 2136)
			{
				strValue = @"DE";
				break;
			}
			if(nCode >= 2137 && nCode <= 2143)
			{
				strValue = @"DENG";
				break;
			}
			if(nCode >= 2144 && nCode <= 2162)
			{
				strValue = @"DI";
				break;
			}
			if(nCode >= 2163 && nCode <= 2178)
			{
				strValue = @"DIAN";
				break;
			}
			if(nCode >= 2179 && nCode <= 2187)
			{
				strValue = @"DIAO";
				break;
			}
			if(nCode >= 2188 && nCode <= 2194)
			{
				strValue = @"DIE";
				break;
			}
			if(nCode >= 2201 && nCode <= 2209)
			{
				strValue = @"DING";
				break;
			}
			if(nCode==2210)
			{
				strValue = @"DIU";
				break;
			}
			if(nCode >= 2211 && nCode <= 2220)
			{
				strValue = @"DONG";
				break;
			}
			if(nCode >= 2221 && nCode <= 2227)
			{
				strValue = @"DOU";
				break;
			}
			if(nCode >= 2228 && nCode <= 2242)
			{
				strValue = @"DU";
				break;
			}
			if(nCode >= 2243 && nCode <= 2248)
			{
				strValue = @"DUAN";
				break;
			}
			if(nCode >= 2249 && nCode <= 2252)
			{
				strValue = @"DUI";
				break;
			}
			if(nCode >= 2253 && nCode <= 2261)
			{
				strValue = @"DUN";
				break;
			}
			if(nCode >= 2262 && nCode <= 2273)
			{
				strValue = @"DUO";
				break;
			}
			if(nCode >= 2274 && nCode <= 2286)
			{
				strValue = @"E";
				break;
			}
			if(nCode==2287)
			{
				strValue = @"EN";
				break;
			}
			if(nCode >= /* DISABLES CODE */ (2288) && nCode <= 2231)
			{
				strValue = @"ER";
				break;
			}
			if(nCode >= 2302 && nCode <= 2309)
			{
				strValue = @"FA";
				break;
			}
			if(nCode >= 2310 && nCode <= 2326)
			{
				strValue = @"FAN";
				break;
			}
			if(nCode >= 2327 && nCode <= 2337)
			{
				strValue = @"FANG";
				break;
			}
			if(nCode >= 2338 && nCode <= 2349)
			{
				strValue = @"FEI";
				break;
			}
			if(nCode >= 2350 && nCode <= 2364)
			{
				strValue = @"FEN";
				break;
			}
			if(nCode >= 2365 && nCode <= 2379)
			{
				strValue = @"FENG";
				break;
			}
			if(nCode==2380)
			{
				strValue = @"FO";
				break;
			}
			if(nCode==2381)
			{
				strValue = @"FOU";
				break;
			}
			if(nCode >= 2382 && nCode <= 2432)
			{
				strValue = @"FU";
				break;
			}
			if(nCode >= 2435 && nCode <= 2440)
			{
				strValue = @"GAI";
				break;
			}
			if(nCode >= 2441 && nCode <= 2451)
			{
				strValue = @"GAN";
				break;
			}
			if(nCode >= 2452 && nCode <= 2460)
			{
				strValue = @"GANG";
				break;
			}
			if(nCode >= 2461 && nCode <= 2470)
			{
				strValue = @"GAO";
				break;
			}
			if(nCode >= 2471 && nCode <= 2487)
			{
				strValue = @"GE";
				break;
			}
			if(nCode==2488)
			{
				strValue = @"GEI";
				break;
			}
			if(nCode >= 2489 && nCode <= 2490)
			{
				strValue = @"GEN";
				break;
			}
			if(nCode >= 2491 && nCode <= 2503)
			{
				strValue = @"GENG";
				break;
			}
			if(nCode >= 2504 && nCode <= 2518)
			{
				strValue = @"GONG";
				break;
			}
			if(nCode >= 2519 && nCode <= 2527)
			{
				strValue = @"GOU";
				break;
			}
			if(nCode >= 2528 && nCode <= 2545)
			{
				strValue = @"GU";
				break;
			}
			if(nCode >= 2546 && nCode <= 2551)
			{
				strValue = @"GUA";
				break;
			}
			if(nCode >= 2552 && nCode <= 2554)
			{
				strValue = @"GUAI";
				break;
			}
			if(nCode >= 2555 && nCode <= 2565)
			{
				strValue = @"GUAN";
				break;
			}
			if(nCode >= 2566 && nCode <= 2568)
			{
				strValue = @"GUANG";
				break;
			}
			if(nCode >= 2569 && nCode <= 2584)
			{
				strValue = @"GUI";
				break;
			}
			if(nCode >= 2585 && nCode <= 2587)
			{
				strValue = @"GUN";
				break;
			}
			if(nCode >= 2588 && nCode <= 2593)
			{
				strValue = @"GUO";
				break;
			}
			if(nCode==2594)
			{
				strValue = @"HA";
				break;
			}
			if(nCode >= 2601 && nCode <= 2607)
			{
				strValue = @"HAI";
				break;
			}
			if(nCode >= 2608 && nCode <= 2626)
			{
				strValue = @"HAN";
				break;
			}
			if(nCode >= 2627 && nCode <= 2629)
			{
				strValue = @"HANG";
				break;
			}
			if(nCode >= 2630 && nCode <= 2638)
			{
				strValue = @"HAO";
				break;
			}
			if(nCode >= 2639 && nCode <= 2656)
			{
				strValue = @"HE";
				break;
			}
			if(nCode >= 2657 && nCode <= 2658)
			{
				strValue = @"HEI";
				break;
			}
			if(nCode >= 2659 && nCode <= 2662)
			{
				strValue = @"HEN";
				break;
			}
			if(nCode >= 2663 && nCode <= 2667)
			{
				strValue = @"HENG";
				break;
			}
			if(nCode >= 2668 && nCode <= 2676)
			{
				strValue = @"HONG";
				break;
			}
			if(nCode >= 2677 && nCode <= 2683)
			{
				strValue = @"HOU";
				break;
			}
			if(nCode >= 2684 && nCode <= 2707)
			{
				strValue = @"HU";
				break;
			}
			if(nCode >= 2708 && nCode <= 2716)
			{
				strValue = @"HUA";
				break;
			}
			if(nCode >= 2717 && nCode <= 2721)
			{
				strValue = @"HUAI";
				break;
			}
			if(nCode >= 2722 && nCode <= 2735)
			{
				strValue = @"HUAN";
				break;
			}
			if(nCode >= 2736 && nCode <= 2749)
			{
				strValue = @"HUANG";
				break;
			}
			if(nCode >= 2750 && nCode <= 2770)
			{
				strValue = @"HUI";
				break;
			}
			if(nCode >= 2771 && nCode <= 2776)
			{
				strValue = @"HUN";
				break;
			}
			if(nCode >= 2777 && nCode <= 2786)
			{
				strValue = @"HUO";
				break;
			}
			if(nCode >= 2787 && nCode <= 2845)
			{
				strValue = @"JI";
				break;
			}
			if(nCode >= 2846 && nCode <= 2862)
			{
				strValue = @"JIA";
				break;
			}
			if(nCode >= 2863 && nCode <= 2908)
			{
				strValue = @"JIAN";
				break;
			}
			if(nCode >= 2909 && nCode <= 2921)
			{
				strValue = @"JIANG";
				break;
			}
			if(nCode >= 2922 && nCode <= 2949)
			{
				strValue = @"JIAO";
				break;
			}
			if(nCode >= 2950 && nCode <= 2976)
			{
				strValue = @"JIE";
				break;
			}
			if(nCode >= 2977 && nCode <= 3002)
			{
				strValue = @"JIN";
				break;
			}
			if(nCode >= 3003 && nCode <= 3027)
			{
				strValue = @"JING";
				break;
			}
			if(nCode >= 3028 && nCode <= 3029)
			{
				strValue = @"JIONG";
				break;
			}
			if(nCode >= 3030 && nCode <= 3046)
			{
				strValue = @"JIU";
				break;
			}
			if(nCode >= 3047 && nCode <= 3071)
			{
				strValue = @"JU";
				break;
			}
			if(nCode >= 3072 && nCode <= 3078)
			{
				strValue = @"JUAN";
				break;
			}
			if(nCode >= 3079 && nCode <= 3088)
			{
				strValue = @"JUE";
				break;
			}
			if(nCode >= 3089 && nCode <= 3105)
			{
				strValue = @"JUN";
				break;
			}
			if(nCode >= 3106 && nCode <= 3109)
			{
				strValue = @"KA";
				break;
			}
			if(nCode >= 3110 && nCode <= 3114)
			{
				strValue = @"KAI";
				break;
			}
			if(nCode >= 3115 && nCode <= 3120)
			{
				strValue = @"KAN";
				break;
			}
			if(nCode >= 3121 && nCode <= 3127)
			{
				strValue = @"KANG";
				break;
			}
			if(nCode >= 3128 && nCode <= 3131)
			{
				strValue = @"KAO";
				break;
			}
			if(nCode >= 3132 && nCode <= 3146)
			{
				strValue = @"KE";
				break;
			}
			if(nCode >= 3147 && nCode <= 3150)
			{
				strValue = @"KEN";
				break;
			}
			if(nCode >= 3151 && nCode <= 3152)
			{
				strValue = @"KENG";
				break;
			}
			if(nCode >= 3153 && nCode <= 3156)
			{
				strValue = @"KONG";
				break;
			}
			if(nCode >= 3157 && nCode <= 3160)
			{
				strValue = @"KOU";
				break;
			}
			if(nCode >= 3161 && nCode <= 3167)
			{
				strValue = @"KU";
				break;
			}
			if(nCode >= 3168 && nCode <= 3172)
			{
				strValue = @"KUA";
				break;
			}
			if(nCode >= 3173 && nCode <= 3176)
			{
				strValue = @"KUAI";
				break;
			}
			if(nCode >= 3177 && nCode <= 3178)
			{
				strValue = @"KUAN";
				break;
			}
			if(nCode >= 3179 && nCode <= 3186)
			{
				strValue = @"KUANG";
				break;
			}
			if(nCode >= 3187 && nCode <= 3203)
			{
				strValue = @"KUI";
				break;
			}
			if(nCode >= 3204 && nCode <= 3207)
			{
				strValue = @"KUN";
				break;
			}
			if(nCode >= 3208 && nCode <= 3211)
			{
				strValue = @"KUO";
				break;
			}
			if(nCode >= 3212 && nCode <= 3218)
			{
				strValue = @"LA";
				break;
			}
			if(nCode >= 3219 && nCode <= 3221)
			{
				strValue = @"LAI";
				break;
			}
			if(nCode >= 3222 && nCode <= 3236)
			{
				strValue = @"LAN";
				break;
			}
			if(nCode >= 3237 && nCode <= 3243)
			{
				strValue = @"LANG";
				break;
			}
			if(nCode >= 3244 && nCode <= 3252)
			{
				strValue = @"LAO";
				break;
			}
			if(nCode >= 3253 && nCode <= 3254)
			{
				strValue = @"LE";
				break;
			}
			if(nCode >= 3255 && nCode <= 3265)
			{
				strValue = @"LEI";
				break;
			}
			if(nCode >= 3266 && nCode <= 3268)
			{
				strValue = @"LENG";
				break;
			}
			if(nCode >= 3269 && nCode <= 3308)
			{
				strValue = @"LI";
			}
			if(nCode==3309)
			{
				strValue = @"LIA";
				break;
			}
			if(nCode >= 3310 && nCode <= 3323)
			{
				strValue = @"LIAN";
				break;
			}
			if(nCode >= 3324 && nCode <= 3334)
			{
				strValue = @"LIANG";
				break;
			}
			if(nCode >= 3335 && nCode <= 3347)
			{
				strValue = @"LIAO";
				break;
			}
			if(nCode >= 3348 && nCode <= 3352)
			{
				strValue = @"LIE";
				break;
			}
			if(nCode >= 3353 && nCode <= 3363)
			{
				strValue = @"LIN";
				break;
			}
			if(nCode >= 3364 && nCode <= 3378)
			{
				strValue = @"LING";
				break;
			}
			if(nCode >= 3379 && nCode <= 3389)
			{
				strValue = @"LIU";
				break;
			}
			if(nCode >= 3390 && nCode <= 3404)
			{
				strValue = @"LONG";
				break;
			}
			if(nCode >= 3405 && nCode <= 3410)
			{
				strValue = @"LOU";
				break;
			}
			if(nCode >= 3411 && nCode <= 3444)
			{
				strValue = @"LU";
				break;
			}
			if(nCode >= 3445 && nCode <= 3450)
			{
				strValue = @"LUAN";
				break;
			}
			if(nCode >= 3451 && nCode <= 3452)
			{
				strValue = @"LUE";
				break;
			}
			if(nCode >= 3453 && nCode <= 3459)
			{
				strValue = @"LUN";
				break;
			}
			if(nCode >= 3460 && nCode <= 3471)
			{
				strValue = @"LUO";
				break;
			}
			if(nCode >= 3472 && nCode <= 3480)
			{
				strValue = @"MA";
				break;
			}
			if(nCode >= 3481 && nCode <= 3486)
			{
				strValue = @"MAI";
				break;
			}
			if(nCode >= 3487 && nCode <= 3501)
			{
				strValue = @"MAN";
				break;
			}
			if(nCode >= 3502 && nCode <= 3507)
			{
				strValue = @"MANG";
				break;
			}
			if(nCode >= 3508 && nCode <= 3519)
			{
				strValue = @"MAO";
				break;
			}
			if(nCode==3520)
			{
				strValue = @"ME";
				break;
			}
			if(nCode >= 3521 && nCode <= 3536)
			{
				strValue = @"MEI";
				break;
			}
			if(nCode >= 3537 && nCode <= 3539)
			{
				strValue = @"MEN";
				break;
			}
			if(nCode >= 3540 && nCode <= 3547)
			{
				strValue = @"MENG";
				break;
			}
			if(nCode >= 3548 && nCode <= 3561)
			{
				strValue = @"MI";
			}
			if(nCode >= 3562 && nCode <= 3570)
			{
				strValue = @"MIAN";
				break;
			}
			if(nCode >= 3571 && nCode <= 3578)
			{
				strValue = @"MIAO";
				break;
			}
			if(nCode >= 3579 && nCode <= 3580)
			{
				strValue = @"MIE";
				break;
			}
			if(nCode >= 3581 && nCode <= 3586)
			{
				strValue = @"MIN";
				break;
			}
			if(nCode >= 3587 && nCode <= 3592)
			{
				strValue = @"MING";
				break;
			}
			if(nCode==3593)
			{
				strValue = @"MIU";
				break;
			}
			if(nCode >= 3594 && nCode <= 3616)
			{
				strValue = @"MO";
				break;
			}
			if(nCode >= 3617 && nCode <= 3619)
			{
				strValue = @"MOU";
				break;
			}
			if(nCode >= 3620 && nCode <= 3634)
			{
				strValue = @"MU";
				break;
			}
			if(nCode >= 3635 && nCode <= 3641)
			{
				strValue = @"NA";
				break;
			}
			if(nCode >= 3642 && nCode <= 3646)
			{
				strValue = @"NAI";
				break;
			}
			if(nCode >= 3647 && nCode <= 3649)
			{
				strValue = @"NAN";
				break;
			}
			if(nCode==3650)
			{
				strValue = @"NANG";
				break;
			}
			if(nCode >= 3651 && nCode <= 3655)
			{
				strValue = @"NAO";
				break;
			}
			if(nCode==3656)
			{
				strValue = @"NE";
				break;
			}
			if(nCode >= 3657 && nCode <= 3658)
			{
				strValue = @"NEI";
				break;
			}
			if(nCode==3659)
			{
				strValue = @"NEN";
				break;
			}
			if(nCode==3660)
			{
				strValue = @"NENG";
				break;
			}
			if(nCode >= 3661 && nCode <= 3671)
			{
				strValue = @"NI";
				break;
			}
			if(nCode >= 3672 && nCode <= 3678)
			{
				strValue = @"NIAN";
				break;
			}
			if(nCode >= 3679 && nCode <= 3680)
			{
				strValue = @"NIANG";
				break;
			}
			if(nCode >= 3681 && nCode <= 3682)
			{
				strValue = @"NIAO";
				break;
			}
			if(nCode >= 3683 && nCode <= 3689)
			{
				strValue = @"NIE";
				break;
			}
			if(nCode==3690)
			{
				strValue = @"NIN";
				break;
			}
			if(nCode >= 3691 && nCode <= 3702)
			{
				strValue = @"NING";
				break;
			}
			if(nCode >= 3703 && nCode <= 3706)
			{
				strValue = @"NIU";
				break;
			}
			if(nCode >= 3707 && nCode <= 3710)
			{
				strValue = @"NONG";
				break;
			}
			if(nCode >= 3711 && nCode <= 3714)
			{
				strValue = @"NU";
				break;
			}
			if(nCode==3715)
			{
				strValue = @"NUAN";
				break;
			}
			if(nCode >= 3716 && nCode <= 3717)
			{
				strValue = @"NUE";
				break;
			}
			if(nCode >= 3718 && nCode <= 3721)
			{
				strValue = @"NUO";
				break;
			}
			if(nCode==3722)
			{
				strValue = @"O";
				break;
			}
			if(nCode >= 3723 && nCode <= 3729)
			{
				strValue = @"OU";
				break;
			}
			if(nCode >= 3730 && nCode <= 3735)
			{
				strValue = @"PA";
				break;
			}
			if(nCode >= 3736 && nCode <= 3741)
			{
				strValue = @"PAI";
				break;
			}
			if(nCode >= 3742 && nCode <= 3749)
			{
				strValue = @"PAN";
				break;
			}
			if(nCode >= 3750 && nCode <= 3754)
			{
				strValue = @"PANG";
				break;
			}
			if(nCode >= 3755 && nCode <= 3761)
			{
				strValue = @"PAO";
				break;
			}
			if(nCode >= 3762 && nCode <= 3770)
			{
				strValue = @"PEI";
				break;
			}
			if(nCode >= 3771 && nCode <= 3772)
			{
				strValue = @"PEN";
				break;
			}
			if(nCode >= 3773 && nCode <= 3786)
			{
				strValue = @"PENG";
				break;
			}
			if(nCode >= 3787 && nCode <= 3809)
			{
				strValue = @"PI";
				break;
			}
			if(nCode >= 3810 && nCode <= 3813)
			{
				strValue = @"PIAN";
				break;
			}
			if(nCode >= 3814 && nCode <= 3817)
			{
				strValue = @"PIAO";
				break;
			}
			if(nCode >= 3818 && nCode <= 3819)
			{
				strValue = @"PIE";
				break;
			}
			if(nCode >= 3820 && nCode <= 3824)
			{
				strValue = @"PIN";
				break;
			}
			if(nCode >= 3825 && nCode <= 3833)
			{
				strValue = @"PING";
				break;
			}
			if(nCode >= 3834 && nCode <= 3841)
			{
				strValue = @"PO";
				break;
			}
			if(nCode==3842)
			{
				strValue = @"POU";
				break;
			}
			if(nCode >= 3843 && nCode <= 3857)
			{
				strValue = @"PU";
				break;
			}
			if(nCode >= 3858 && nCode <= 3893)
			{
				strValue = @"QI";
				break;
			}
			if(nCode==3894||(nCode >= 3901 && nCode <= 3902))
			{
				strValue = @"QIA";
				break;
			}
			if(nCode >= 3903 && nCode <= 3924)
			{
				strValue = @"QIAN";
				break;
			}
			if(nCode >= 3925 && nCode <= 3932)
			{
				strValue = @"QIANG";
				break;
			}
			if(nCode >= 3933 && nCode <= 3947)
			{
				strValue = @"QIAO";
				break;
			}
			if(nCode >= 3948 && nCode <= 3952)
			{
				strValue = @"QIE";
				break;
			}
			if(nCode >= 3953 && nCode <= 3963)
			{
				strValue = @"QIN";
				break;
			}
			if(nCode >= 3964 && nCode <= 3976)
			{
				strValue = @"QING";
				break;
			}
			if(nCode >= 3977 && nCode <= 3978)
			{
				strValue = @"QIONG";
				break;
			}
			if(nCode >= 3979 && nCode <= 3986)
			{
				strValue = @"QIU";
				break;
			}
			if(nCode >= 3987 && nCode <= 4005)
			{
				strValue = @"QU";
				break;
			}
			if(nCode >= 4006 && nCode <= 4016)
			{
				strValue = @"QUAN";
				break;
			}
			if(nCode >= 4017 && nCode <= 4024)
			{
				strValue = @"QUE";
				break;
			}
			if(nCode >= 4025 && nCode <= 4026)
			{
				strValue = @"QUN";
				break;
			}
			if(nCode >= 4027 && nCode <= 4030)
			{
				strValue = @"RAN";
				break;
			}
			if(nCode >= 4031 && nCode <= 4035)
			{
				strValue = @"RANG";
			}
			if(nCode >= 4036 && nCode <= 4038)
			{
				strValue = @"RAO";
				break;
			}
			if(nCode >= 4039 && nCode <= 4040)
			{
				strValue = @"RE";
				break;
			}
			if(nCode >= 4041 && nCode <= 4050)
			{
				strValue = @"REN";
				break;
			}
			if(nCode >= 4051 && nCode <= 4052)
			{
				strValue = @"RENG";
				break;
			}
			if(nCode==4053)
			{
				strValue = @"RI";
				break;
			}
			if(nCode >= 4054 && nCode <= 4063)
			{
				strValue = @"RONG";
				break;
			}
			if(nCode >= 4064 && nCode <= 4066)
			{
				strValue = @"ROU";
				break;
			}
			if(nCode >= 4067 && nCode <= 4076)
			{
				strValue = @"RU";
				break;
			}
			if(nCode >= 4077 && nCode <= 4078)
			{
				strValue = @"RUAN";
				break;
			}
			if(nCode >= 4079 && nCode <= 4081)
			{
				strValue = @"RUI";
				break;
			}
			if(nCode >= 4082 && nCode <= 4083)
			{
				strValue = @"RUN";
				break;
			}
			if(nCode >= 4084 && nCode <= 4085)
			{
				strValue = @"RUO";
				break;
			}
			if(nCode >= 4086 && nCode <= 4088)
			{
				strValue = @"SA";
				break;
			}
			if(nCode >= 4089 && nCode <= 4092)
			{
				strValue = @"SAI";
				break;
			}
			if(nCode >= 4093 && nCode <= 4094)
			{
				strValue = @"SAN";
				break;
			}
			if(nCode >= 4101 && nCode <= 4102)
			{
				strValue = @"SAN";
				break;
			}
			if(nCode >= 4103 && nCode <= 4105)
			{
				strValue = @"SANG";
				break;
			}
			if(nCode >= 4106 && nCode <= 4109)
			{
				strValue = @"SAO";
				break;
			}
			if(nCode >= 4110 && nCode <= 4112)
			{
				strValue = @"SE";
				break;
			}
			if(nCode==4113)
			{
				strValue = @"SEN";
			}
			if(nCode==4114)
			{
				strValue = @"SENG";
				break;
			}
			if(nCode >= 4115 && nCode <= 4123)
			{
				strValue = @"SHA";
				break;
			}
			if(nCode >= 4124 && nCode <= 4125)
			{
				strValue = @"SHAI";
				break;
			}
			if(nCode >= 4126 && nCode <= 4141)
			{
				strValue = @"SHAN";
				break;
			}
			if(nCode >= 4142 && nCode <= 4149)
			{
				strValue = @"SHANG";
				break;
			}
			if(nCode >= 4150 && nCode <= 4160)
			{
				strValue = @"SHAO";
				break;
			}
			if(nCode >= 4161 && nCode <= 4172)
			{
				strValue = @"SHE";
				break;
			}
			if(nCode >= 4173 && nCode <= 4188)
			{
				strValue = @"SHEN";
				break;
			}
			if(nCode >= 4189 && nCode <= 4205)
			{
				strValue = @"SHENG";
				break;
			}
			if(nCode >= 4206 && nCode <= 4252)
			{
				strValue = @"SHI";
				break;
			}
			if(nCode >= 4253 && nCode <= 4262)
			{
				strValue = @"SHOU";
				break;
			}
			if(nCode >= 4263 && nCode <= 4301)
			{
				strValue = @"SHU";
				break;
			}
			if(nCode >= 4302 && nCode <= 4303)
			{
				strValue = @"SHUA";
				break;
			}
			if(nCode >= 4304 && nCode <= 4307)
			{
				strValue = @"SHUAI";
				break;
			}
			if(nCode >= 4308 && nCode <= 4309)
			{
				strValue = @"SHUAN";
				break;
			}
			if(nCode >= 4310 && nCode <= 4312)
			{
				strValue = @"SHUANG";
				break;
			}
			if(nCode >= 4313 && nCode <= 4316)
			{
				strValue = @"SHUI";
				break;
			}
			if(nCode >= 4317 && nCode <= 4320)
			{
				strValue = @"SHUN";
				break;
			}
			if(nCode >= 4321 && nCode <= 4324)
			{
				strValue = @"SHUO";
				break;
			}
			if(nCode >= 4325 && nCode <= 4340)
			{
				strValue = @"SI";
				break;
			}
			if(nCode >= 4341 && nCode <= 4348)
			{
				strValue = @"SONG";
				break;
			}
			if(nCode >= 4349 && nCode <= 4352)
			{
				strValue = @"SOU";
				break;
			}
			if(nCode >= 4353 && nCode <= 4364)
			{
				strValue = @"SU";
				break;
			}
			if(nCode >= 4365 && nCode <= 4367)
			{
				strValue = @"SUAN";
				break;
			}
			if(nCode >= 4368 && nCode <= 4378)
			{
				strValue = @"SUI";
				break;
			}
			if(nCode >= 4379 && nCode <= 4381)
			{
				strValue = @"SUN";
				break;
			}
			if(nCode >= 4382 && nCode <= 4389)
			{
				strValue = @"SUO";
				break;
			}
			if(nCode >= 4390 && nCode <= 4404)
			{
				strValue = @"TA";
				break;
			}
			if(nCode >= 4405 && nCode <= 4413)
			{
				strValue = @"TAI";
				break;
			}
			if(nCode >= 4414 && nCode <= 4431)
			{
				strValue = @"TAN";
				break;
			}
			if(nCode >= 4432 && nCode <= 4444)
			{
				strValue = @"TANG";
				break;
			}
			if(nCode >= 4445 && nCode <= 4455)
			{
				strValue = @"TAO";
				break;
			}
			if(nCode==4456)
			{
				strValue = @"TE";
				break;
			}
			if(nCode >= 4457 && nCode <= 4460)
			{
				strValue = @"TENG";
				break;
			}
			if(nCode >= 4461 && nCode <= 4475)
			{
				strValue = @"TI";
				break;
			}
			if(nCode >= 4476 && nCode <= 4483)
			{
				strValue = @"TIAN";
				break;
			}
			if(nCode >= 4484 && nCode <= 4488)
			{
				strValue = @"TIAO";
				break;
			}
			if(nCode >= 4489 && nCode <= 4491)
			{
				strValue = @"TIE";
				break;
			}
			if(nCode >= 4492 && nCode <= 4507)
			{
				strValue = @"TING";
				break;
			}
			if(nCode >= 4508 && nCode <= 4520)
			{
				strValue = @"TONG";
				break;
			}
			if(nCode >= 4521 && nCode <= 4524)
			{
				strValue = @"TOU";
				break;
			}
			if(nCode >= 4525 && nCode <= 4535)
			{
				strValue = @"TU";
				break;
			}
			if(nCode >= 4536 && nCode <= 4537)
			{
				strValue = @"TUAN";
				break;
			}
			if(nCode >= 4538 && nCode <= 4543)
			{
				strValue = @"TUI";
				break;
			}
			if(nCode >= 4544 && nCode <= 4546)
			{
				strValue = @"TUN";
				break;
			}
			if(nCode >= 4547 && nCode <= 4557)
			{
				strValue = @"TUO";
				break;
			}
			if(nCode >= 4558 && nCode <= 4564)
			{
				strValue = @"WA";
				break;
			}
			if(nCode >= 4565 && nCode <= 4566)
			{
				strValue = @"WAI";
				break;
			}
			if(nCode >= 4567 && nCode <= 4583)
			{
				strValue = @"WAN";
				break;
			}
			if(nCode >= 4584 && nCode <= 4593)
			{
				strValue = @"WANG";
				break;
			}
			if(nCode >= 4594 && nCode <= 4632)
			{
				strValue = @"WEI";
				break;
			}
			if(nCode >= 4633 && nCode <= 4642)
			{
				strValue = @"WEN";
				break;
			}
			if(nCode >= 4643 && nCode <= 4645)
			{
				strValue = @"WENG";
				break;
			}
			if(nCode >= 4646 && nCode <= 4654)
			{
				strValue = @"WO";
				break;
			}
			if(nCode >= 4655 && nCode <= 4683)
			{
				strValue = @"WU";
				break;
			}
			if(nCode >= 4684 && nCode <= 4724)
			{
				strValue = @"XI";
				break;
			}
			if(nCode >= 4725 && nCode <= 4737)
			{
				strValue = @"XIA";
				break;
			}
			if(nCode >= 4738 && nCode <= 4763)
			{
				strValue = @"XIAN";
				break;
			}
			if(nCode >= 4764 && nCode <= 4783)
			{
				strValue = @"XIANG";
				break;
			}
			if(nCode >= 4784 && nCode <= 4807)
			{
				strValue = @"XIAO";
				break;
			}
			if(nCode >= 4809 && nCode <= 4828)
			{
				strValue = @"XIE";
				break;
			}
			if(nCode >= 4829 && nCode <= 4838)
			{
				strValue = @"XIN";
				break;
			}
			if(nCode >= 4839 && nCode <= 4853)
			{
				strValue = @"XING";
				break;
			}
			if(nCode >= 4854 && nCode <= 4860)
			{
				strValue = @"XIONG";
				break;
			}
			if(nCode >= 4861 && nCode <= 4869)
			{
				strValue = @"XIU";
				break;
			}
			if(nCode >= 4870 && nCode <= 4888)
			{
				strValue = @"XU";
				break;
			}
			if(nCode >= 4889 && nCode <= 4904)
			{
				strValue = @"XUAN";
				break;
			}
			if(nCode >= 4905 && nCode <= 4910)
			{
				strValue = @"XUE";
				break;
			}
			if(nCode >= 4911 && nCode <= 4924)
			{
				strValue = @"XUN";
				break;
			}
			if(nCode >= 4925 && nCode <= 4940)
			{
				strValue = @"YA";
				break;
			}
			if(nCode >= 4941 && nCode <= 4973)
			{
				strValue = @"YAN";
				break;
			}
			if(nCode >= 4974 && nCode <= 4990)
			{
				strValue = @"YANG";
				break;
			}
			if(nCode >= 4991 && nCode <= 5011)
			{
				strValue = @"YAO";
				break;
			}
			if(nCode >= 5012 && nCode <= 5026)
			{
				strValue = @"YE";
				break;
			}
			if(nCode >= 5027 && nCode <= 5079)
			{
				strValue = @"YI";
				break;
			}
			if(nCode >= 5080 && nCode <= 5101)
			{
				strValue = @"YIN";
				break;
			}
			if(nCode >= 5102 && nCode <= 5119)
			{
				strValue = @"YING";
				break;
			}
			if(nCode==5120)
			{
				strValue = @"YO";
				break;
			}
			if(nCode >= 5121 && nCode <= 5135)
			{
				strValue = @"YONG";
				break;
			}
			if(nCode >= 5136 && nCode <= 5155)
			{
				strValue = @"YOU";
				break;
			}
			if(nCode >= 5156 && nCode <= 5206)
			{
				strValue = @"YU";
				break;
			}
			if(nCode >= 5207 && nCode <= 5226)
			{
				strValue = @"YUAN";
				break;
			}
			if(nCode >= 5227 && nCode <= 5236)
			{
				strValue = @"YUE";
				break;
			}
			if(nCode >= 5237 && nCode <= 5248)
			{
				strValue = @"YUN";
				break;
			}
			if(nCode >= 5249 && nCode <= 5251)
			{
				strValue = @"ZA";
				break;
			}
			if(nCode >= 5252 && nCode <= 5258)
			{
				strValue = @"ZAI";
				break;
			}
			if(nCode >= 5259 && nCode <= 5262)
			{
				strValue = @"ZAN";
				break;
			}
			if(nCode >= 5263 && nCode <= 5265)
			{
				strValue = @"ZANG";
				break;
			}
			if(nCode >= 5266 && nCode <= 5279)
			{
				strValue = @"ZAO";
				break;
			}
			if(nCode >= 5280 && nCode <= 5283)
			{
				strValue = @"ZE";
				break;
			}
			if(nCode==5284)
			{
				strValue = @"ZEI";
				break;
			}
			if(nCode==5285)
			{
				strValue = @"ZEN";
				break;
			}
			if(nCode >= 5286 && nCode <= 5289)
			{
				strValue = @"ZENG";
				break;
			}
			if(nCode >= 5290 && nCode <= 5309)
			{
				strValue = @"ZHA";
				break;
			}
			if(nCode >= 5310 && nCode <= 5315)
			{
				strValue = @"ZHAI";
				break;
			}
			if(nCode >= 5316 && nCode <= 5332)
			{
				strValue = @"ZHAN";
				break;
			}
			if(nCode >= 5333 && nCode <= 5347)
			{
				strValue = @"ZHANG";
				break;
			}
			if(nCode >= 5348 && nCode <= 5357)
			{
				strValue = @"ZHAO";
				break;
			}
			if(nCode >= 5358 && nCode <= 5367)
			{
				strValue = @"ZHE";
				break;
			}
			if(nCode >= 5368 && nCode <= 5383)
			{
				strValue = @"ZHEN";
				break;
			}
			if(nCode >= 5384 && nCode <= 5404)
			{
				strValue = @"ZHENG";
				break;
			}
			if(nCode >= 5405 && nCode <= 5447)
			{
				strValue = @"ZHI";
				break;
			}
			if(nCode >= 5448 && nCode <= 5458)
			{
				strValue = @"ZHONG";
				break;
			}
			if(nCode >= 5459 && nCode <= 5472)
			{
				strValue = @"ZHOU";
				break;
			}
			if(nCode >= 5473 && nCode <= 5504)
			{
				strValue = @"ZHU";
				break;
			}
			if(nCode >= 5505 && nCode <= 5506)
			{
				strValue = @"ZHUA";
				break;
			}
			if(nCode==5507)
			{
				strValue = @"ZHUAI";
				break;
			}
			if(nCode >= 5508 && nCode <= 5513)
			{
				strValue = @"ZHUAN";
				break;
			}
			if(nCode >= 5514 && nCode <= 5520)
			{
				strValue = @"ZHUANG";
				break;
			}
			if(nCode >= 5521 && nCode <= 5526)
			{
				strValue = @"ZHUI";
				break;
			}
			if(nCode >= 5527 && nCode <= 5528)
			{
				strValue = @"ZHUN";
				break;
			}
			if(nCode >= 5529 && nCode <= 5539)
			{
				strValue = @"ZHUO";
				break;
			}
			if(nCode >= 5540 && nCode <= 5554)
			{
				strValue = @"ZI";
				break;
			}
			if(nCode >= 5555 && nCode <= 5561)
			{
				strValue = @"ZONG";
				break;
			}
			if(nCode >= 5562 && nCode <= 5565)
			{
				strValue = @"ZOU";
				break;
			}
			if(nCode >= 5566 && nCode <= 5573)
			{
				strValue = @"ZU";
				break;
			}
			if(nCode >= 5574 && nCode <= 5575)
			{
				strValue = @"ZUAN";
				break;
			}
			if(nCode >= 5576 && nCode <= 5579)
			{
				strValue = @"ZUI";
				break;
			}
			if(nCode >= 5580 && nCode <= 5581)
			{
				strValue = @"ZUN";
				break;
			}
			if(nCode >= 5582 && nCode <= 5589)
			{
				strValue = @"ZUO";
				break;
			}
	}
	return strValue;
}

#define HANZI_START 19968
#define HANZI_COUNT 20902

static char firstLetterArray[HANZI_COUNT] = 
"ydkqsxnwzssxjbymgcczqpssqbycdscdqldylybssjgyqzjjfgcclzznwdwzjljpfyynnjjtmynzwzhflzppqhgccyynmjqyxxgd"
"nnsnsjnjnsnnmlnrxyfsngnnnnqzggllyjlnyzssecykyyhqwjssggyxyqyjtwktjhychmnxjtlhjyqbyxdldwrrjnwysrldzjpc"
"bzjjbrcfslnczstzfxxchtrqggddlyccssymmrjcyqzpwwjjyfcrwfdfzqpyddwyxkyjawjffxjbcftzyhhycyswccyxsclcxxwz"
"cxnbgnnxbxlzsqsbsjpysazdhmdzbqbscwdzzyytzhbtsyyfzgntnxjywqnknphhlxgybfmjnbjhhgqtjcysxstkzglyckglysmz"
"xyalmeldccxgzyrjxjzlnjzcqkcnnjwhjczccqljststbnhbtyxceqxkkwjyflzqlyhjxspsfxlmpbysxxxytccnylllsjxfhjxp"
"jbtffyabyxbcczbzyclwlczggbtssmdtjcxpthyqtgjjxcjfzkjzjqnlzwlslhdzbwjncjzyzsqnycqynzcjjwybrtwpyftwexcs"
"kdzctbyhyzqyyjxzcfbzzmjyxxsdczottbzljwfckscsxfyrlrygmbdthjxsqjccsbxyytswfbjdztnbcnzlcyzzpsacyzzsqqcs"
"hzqydxlbpjllmqxqydzxsqjtzpxlcglqdcwzfhctdjjsfxjejjtlbgxsxjmyjjqpfzasyjnsydjxkjcdjsznbartcclnjqmwnqnc"
"lllkbdbzzsyhqcltwlccrshllzntylnewyzyxczxxgdkdmtcedejtsyyssdqdfmxdbjlkrwnqlybglxnlgtgxbqjdznyjsjyjcjm"
"rnymgrcjczgjmzmgxmmryxkjnymsgmzzymknfxmbdtgfbhcjhkylpfmdxlxjjsmsqgzsjlqdldgjycalcmzcsdjllnxdjffffjcn" //
"fnnffpfkhkgdpqxktacjdhhzdddrrcfqyjkqccwjdxhwjlyllzgcfcqjsmlzpbjjblsbcjggdckkdezsqcckjgcgkdjtjllzycxk"
"lqccgjcltfpcqczgwbjdqyzjjbyjhsjddwgfsjgzkcjctllfspkjgqjhzzljplgjgjjthjjyjzccmlzlyqbgjwmljkxzdznjqsyz"
"mljlljkywxmkjlhskjhbmclyymkxjqlbmllkmdxxkwyxwslmlpsjqqjqxyqfjtjdxmxxllcrqbsyjbgwynnggbcnxpjtgpapfgdj"
"qbhbncfjyzjkjkhxqfgqckfhygkhdkllsdjqxpqyaybnqsxqnszswhbsxwhxwbzzxdmndjbsbkbbzklylxgwxjjwaqzmywsjqlsj"
"xxjqwjeqxnchetlzalyyyszzpnkyzcptlshtzcfycyxyljsdcjqagyslcllyyysslqqqnldxzsccscadycjysfsgbfrsszqsbxjp"
"sjysdrckgjlgtkzjzbdktcsyqpyhstcldjnhmymcgxyzhjdctmhltxzhylamoxyjcltyfbqqjpfbdfehthsqhzywwcncxcdwhowg"
"yjlegmdqcwgfjhcsntmydolbygnqwesqpwnmlrydzszzlyqpzgcwxhnxpyxshmdqjgztdppbfbhzhhjyfdzwkgkzbldnzsxhqeeg"
"zxylzmmzyjzgszxkhkhtxexxgylyapsthxdwhzydpxagkydxbhnhnkdnjnmyhylpmgecslnzhkxxlbzzlbmlsfbhhgsgyyggbhsc"
"yajtxglxtzmcwzydqdqmngdnllszhngjzwfyhqswscelqajynytlsxthaznkzzsdhlaxxtwwcjhqqtddwzbcchyqzflxpslzqgpz"
"sznglydqtbdlxntctajdkywnsyzljhhdzckryyzywmhychhhxhjkzwsxhdnxlyscqydpslyzwmypnkxyjlkchtyhaxqsyshxasmc"
"hkdscrsgjpwqsgzjlwwschsjhsqnhnsngndantbaalczmsstdqjcjktscjnxplggxhhgoxzcxpdmmhldgtybynjmxhmrzplxjzck"
"zxshflqxxcdhxwzpckczcdytcjyxqhlxdhypjqxnlsyydzozjnhhqezysjyayxkypdgxddnsppyzndhthrhxydpcjjhtcnnctlhb"
"ynyhmhzllnnxmylllmdcppxhmxdkycyrdltxjchhznxclcclylnzsxnjzzlnnnnwhyqsnjhxynttdkyjpychhyegkcwtwlgjrlgg"
"tgtygyhpyhylqyqgcwyqkpyyettttlhyylltyttsylnyzwgywgpydqqzzdqnnkcqnmjjzzbxtqfjkdffbtkhzkbxdjjkdjjtlbwf"
"zpptkqtztgpdwntpjyfalqmkgxbcclzfhzcllllanpnxtjklcclgyhdzfgyddgcyyfgydxkssendhykdndknnaxxhbpbyyhxccga"
"pfqyjjdmlxcsjzllpcnbsxgjyndybwjspcwjlzkzddtacsbkzdyzypjzqsjnkktknjdjgyepgtlnyqnacdntcyhblgdzhbbydmjr"
"egkzyheyybjmcdtafzjzhgcjnlghldwxjjkytcyksssmtwcttqzlpbszdtwcxgzagyktywxlnlcpbclloqmmzsslcmbjcsdzkydc"
"zjgqjdsmcytzqqlnzqzxssbpkdfqmddzzsddtdmfhtdycnaqjqkypbdjyyxtljhdrqxlmhkydhrnlklytwhllrllrcxylbnsrnzz"
"symqzzhhkyhxksmzsyzgcxfbnbsqlfzxxnnxkxwymsddyqnggqmmyhcdzttfgyyhgsbttybykjdnkyjbelhdypjqnfxfdnkzhqks"
"byjtzbxhfdsbdaswpawajldyjsfhblcnndnqjtjnchxfjsrfwhzfmdrfjyxwzpdjkzyjympcyznynxfbytfyfwygdbnzzzdnytxz"
"emmqbsqehxfznbmflzzsrsyqjgsxwzjsprytjsjgskjjgljjynzjjxhgjkymlpyyycxycgqzswhwlyrjlpxslcxmnsmwklcdnkny"
"npsjszhdzeptxmwywxyysywlxjqcqxzdclaeelmcpjpclwbxsqhfwrtfnjtnqjhjqdxhwlbyccfjlylkyynldxnhycstyywncjtx"
"ywtrmdrqnwqcmfjdxzmhmayxnwmyzqtxtlmrspwwjhanbxtgzypxyyrrclmpamgkqjszycymyjsnxtplnbappypylxmyzkynldgy"
"jzcchnlmzhhanqnbgwqtzmxxmllhgdzxnhxhrxycjmffxywcfsbssqlhnndycannmtcjcypnxnytycnnymnmsxndlylysljnlxys"
"sqmllyzlzjjjkyzzcsfbzxxmstbjgnxnchlsnmcjscyznfzlxbrnnnylmnrtgzqysatswryhyjzmgdhzgzdwybsscskxsyhytsxg"
"cqgxzzbhyxjscrhmkkbsczjyjymkqhzjfnbhmqhysnjnzybknqmcjgqhwlsnzswxkhljhyybqcbfcdsxdldspfzfskjjzwzxsddx"
"jseeegjscssygclxxnwwyllymwwwgydkzjggggggsycknjwnjpcxbjjtqtjwdsspjxcxnzxnmelptfsxtllxcljxjjljsxctnswx"
"lennlyqrwhsycsqnybyaywjejqfwqcqqcjqgxaldbzzyjgkgxbltqyfxjltpydkyqhpmatlcndnkxmtxynhklefxdllegqtymsaw"
"hzmljtkynxlyjzljeeyybqqffnlyxhdsctgjhxywlkllxqkcctnhjlqmkkzgcyygllljdcgydhzwypysjbzjdzgyzzhywyfqdtyz"
"szyezklymgjjhtsmqwyzljyywzcsrkqyqltdxwcdrjalwsqzwbdcqyncjnnszjlncdcdtlzzzacqqzzddxyblxcbqjylzllljddz"
"jgyqyjzyxnyyyexjxksdaznyrdlzyyynjlslldyxjcykywnqcclddnyyynycgczhjxcclgzqjgnwnncqqjysbzzxyjxjnxjfzbsb"
"dsfnsfpzxhdwztdmpptflzzbzdmyypqjrsdzsqzsqxbdgcpzswdwcsqzgmdhzxmwwfybpngphdmjthzsmmbgzmbzjcfzhfcbbnmq"
"dfmbcmcjxlgpnjbbxgyhyyjgptzgzmqbqdcgybjxlwnkydpdymgcftpfxyztzxdzxtgkptybbclbjaskytssqyymscxfjhhlslls"
"jpqjjqaklyldlycctsxmcwfgngbqxllllnyxtyltyxytdpjhnhgnkbyqnfjyyzbyyessessgdyhfhwtcqbsdzjtfdmxhcnjzymqw"
"srxjdzjqbdqbbsdjgnfbknbxdkqhmkwjjjgdllthzhhyyyyhhsxztyyyccbdbpypzyccztjpzywcbdlfwzcwjdxxhyhlhwczxjtc"
"nlcdpxnqczczlyxjjcjbhfxwpywxzpcdzzbdccjwjhmlxbqxxbylrddgjrrctttgqdczwmxfytmmzcwjwxyywzzkybzcccttqnhx"
"nwxxkhkfhtswoccjybcmpzzykbnnzpbthhjdlszddytyfjpxyngfxbyqxzbhxcpxxtnzdnnycnxsxlhkmzxlthdhkghxxsshqyhh"
"cjyxglhzxcxnhekdtgqxqypkdhentykcnymyyjmkqyyyjxzlthhqtbyqhxbmyhsqckwwyllhcyylnneqxqwmcfbdccmljggxdqkt"
"lxkknqcdgcjwyjjlyhhqyttnwchhxcxwherzjydjccdbqcdgdnyxzdhcqrxcbhztqcbxwgqwyybxhmbymykdyecmqkyaqyngyzsl"
"fnkkqgyssqyshngjctxkzycssbkyxhyylstycxqthysmnscpmmgcccccmnztasmgqzjhklosjylswtmqzyqkdzljqqyplzycztcq"
"qpbbcjzclpkhqcyyxxdtdddsjcxffllchqxmjlwcjcxtspycxndtjshjwhdqqqckxyamylsjhmlalygxcyydmamdqmlmcznnyybz"
"xkyflmcncmlhxrcjjhsylnmtjggzgywjxsrxcwjgjqhqzdqjdcjjskjkgdzcgjjyjylxzxxcdqhhheslmhlfsbdjsyyshfyssczq"
"lpbdrfnztzdkykhsccgkwtqzckmsynbcrxqbjyfaxpzzedzcjykbcjwhyjbqzzywnyszptdkzpfpbaztklqnhbbzptpptyzzybhn"
"ydcpzmmcycqmcjfzzdcmnlfpbplngqjtbttajzpzbbdnjkljqylnbzqhksjznggqstzkcxchpzsnbcgzkddzqanzgjkdrtlzldwj"
"njzlywtxndjzjhxnatncbgtzcsskmljpjytsnwxcfjwjjtkhtzplbhsnjssyjbhbjyzlstlsbjhdnwqpslmmfbjdwajyzccjtbnn"
"nzwxxcdslqgdsdpdzgjtqqpsqlyyjzlgyhsdlctcbjtktyczjtqkbsjlgnnzdncsgpynjzjjyyknhrpwszxmtncszzyshbyhyzax"
"ywkcjtllckjjtjhgcssxyqyczbynnlwqcglzgjgqyqcczssbcrbcskydznxjsqgxssjmecnstjtpbdlthzwxqwqczexnqczgwesg"
"ssbybstscslccgbfsdqnzlccglllzghzcthcnmjgyzazcmsksstzmmzckbjygqljyjppldxrkzyxccsnhshhdznlzhzjjcddcbcj"
"xlbfqbczztpqdnnxljcthqzjgylklszzpcjdscqjhjqkdxgpbajynnsmjtzdxlcjyryynhjbngzjkmjxltbsllrzpylssznxjhll"
"hyllqqzqlsymrcncxsljmlzltzldwdjjllnzggqxppskyggggbfzbdkmwggcxmcgdxjmcjsdycabxjdlnbcddygskydqdxdjjyxh"
"saqazdzfslqxxjnqzylblxxwxqqzbjzlfbblylwdsljhxjyzjwtdjcyfqzqzzdzsxzzqlzcdzfxhwspynpqzmlpplffxjjnzzyls"
"jnyqzfpfzgsywjjjhrdjzzxtxxglghtdxcskyswmmtcwybazbjkshfhgcxmhfqhyxxyzftsjyzbxyxpzlchmzmbxhzzssyfdmncw"
"dabazlxktcshhxkxjjzjsthygxsxyyhhhjwxkzxssbzzwhhhcwtzzzpjxsyxqqjgzyzawllcwxznxgyxyhfmkhydwsqmnjnaycys"
"pmjkgwcqhylajgmzxhmmcnzhbhxclxdjpltxyjkdyylttxfqzhyxxsjbjnayrsmxyplckdnyhlxrlnllstycyyqygzhhsccsmcct"
"zcxhyqfpyyrpbflfqnntszlljmhwtcjqyzwtlnmlmdwmbzzsnzrbpdddlqjjbxtcsnzqqygwcsxfwzlxccrszdzmcyggdyqsgtnn"
"nlsmymmsyhfbjdgyxccpshxczcsbsjyygjmpbwaffyfnxhydxzylremzgzzyndsznlljcsqfnxxkptxzgxjjgbmyyssnbtylbnlh"
"bfzdcyfbmgqrrmzszxysjtznnydzzcdgnjafjbdknzblczszpsgcycjszlmnrznbzzldlnllysxsqzqlcxzlsgkbrxbrbzcycxzj"
"zeeyfgklzlnyhgzcgzlfjhgtgwkraajyzkzqtsshjjxdzyznynnzyrzdqqhgjzxsszbtkjbbfrtjxllfqwjgclqtymblpzdxtzag"
"bdhzzrbgjhwnjtjxlkscfsmwlldcysjtxkzscfwjlbnntzlljzllqblcqmqqcgcdfpbphzczjlpyyghdtgwdxfczqyyyqysrclqz"
"fklzzzgffcqnwglhjycjjczlqzzyjbjzzbpdcsnnjgxdqnknlznnnnpsntsdyfwwdjzjysxyyczcyhzwbbyhxrylybhkjksfxtjj"
"mmchhlltnyymsxxyzpdjjycsycwmdjjkqyrhllngpngtlyycljnnnxjyzfnmlrgjjtyzbsyzmsjyjhgfzqmsyxrszcytlrtqzsst"
"kxgqkgsptgxdnjsgcqcqhmxggztqydjjznlbznxqlhyqgggthqscbyhjhhkyygkggcmjdzllcclxqsftgjslllmlcskctbljszsz"
"mmnytpzsxqhjcnnqnyexzqzcpshkzzyzxxdfgmwqrllqxrfztlystctmjcsjjthjnxtnrztzfqrhcgllgcnnnnjdnlnnytsjtlny"
"xsszxcgjzyqpylfhdjsbbdczgjjjqzjqdybssllcmyttmqnbhjqmnygjyeqyqmzgcjkpdcnmyzgqllslnclmholzgdylfzslncnz"
"lylzcjeshnyllnxnjxlyjyyyxnbcljsswcqqnnyllzldjnllzllbnylnqchxyyqoxccqkyjxxxyklksxeyqhcqkkkkcsnyxxyqxy"
"gwtjohthxpxxhsnlcykychzzcbwqbbwjqcscszsslcylgddsjzmmymcytsdsxxscjpqqsqylyfzychdjynywcbtjsydchcyddjlb"
"djjsodzyqyskkyxdhhgqjyohdyxwgmmmazdybbbppbcmnnpnjzsmtxerxjmhqdntpjdcbsnmssythjtslmltrcplzszmlqdsdmjm"
"qpnqdxcfrnnfsdqqyxhyaykqyddlqyyysszbydslntfgtzqbzmchdhczcwfdxtmqqsphqwwxsrgjcwnntzcqmgwqjrjhtqjbbgwz"
"fxjhnqfxxqywyyhyccdydhhqmrmtmwctbszppzzglmzfollcfwhmmsjzttdhlmyffytzzgzyskjjxqyjzqbhmbzclyghgfmshpcf"
"zsnclpbqsnjyzslxxfpmtyjygbxlldlxpzjyzjyhhzcywhjylsjexfszzywxkzjlnadymlymqjpwxxhxsktqjezrpxxzghmhwqpw"
"qlyjjqjjzszcnhjlchhnxjlqwzjhbmzyxbdhhypylhlhlgfwlcfyytlhjjcwmscpxstkpnhjxsntyxxtestjctlsslstdlllwwyh"
"dnrjzsfgxssyczykwhtdhwjglhtzdqdjzxxqgghltzphcsqfclnjtclzpfstpdynylgmjllycqhynspchylhqyqtmzymbywrfqyk"
"jsyslzdnjmpxyyssrhzjnyqtqdfzbwwdwwrxcwggyhxmkmyyyhmxmzhnksepmlqqmtcwctmxmxjpjjhfxyyzsjzhtybmstsyjznq"
"jnytlhynbyqclcycnzwsmylknjxlggnnpjgtysylymzskttwlgsmzsylmpwlcwxwqcssyzsyxyrhssntsrwpccpwcmhdhhxzdzyf"
"jhgzttsbjhgyglzysmyclllxbtyxhbbzjkssdmalhhycfygmqypjyjqxjllljgclzgqlycjcctotyxmtmshllwlqfxymzmklpszz"
"cxhkjyclctyjcyhxsgyxnnxlzwpyjpxhjwpjpwxqqxlxsdhmrslzzydwdtcxknstzshbsccstplwsscjchjlcgchssphylhfhhxj"
"sxallnylmzdhzxylsxlmzykcldyahlcmddyspjtqjzlngjfsjshctsdszlblmssmnyymjqbjhrzwtyydchjljapzwbgqxbkfnbjd"
"llllyylsjydwhxpsbcmljpscgbhxlqhyrljxyswxhhzlldfhlnnymjljyflyjycdrjlfsyzfsllcqyqfgqyhnszlylmdtdjcnhbz"
"llnwlqxygyyhbmgdhxxnhlzzjzxczzzcyqzfngwpylcpkpykpmclgkdgxzgxwqbdxzzkzfbddlzxjtpjpttbythzzdwslcpnhslt"
"jxxqlhyxxxywzyswttzkhlxzxzpyhgzhknfsyhntjrnxfjcpjztwhplshfcrhnslxxjxxyhzqdxqwnnhyhmjdbflkhcxcwhjfyjc"
"fpqcxqxzyyyjygrpynscsnnnnchkzdyhflxxhjjbyzwttxnncyjjymswyxqrmhxzwfqsylznggbhyxnnbwttcsybhxxwxyhhxyxn"
"knyxmlywrnnqlxbbcljsylfsytjzyhyzawlhorjmnsczjxxxyxchcyqryxqzddsjfslyltsffyxlmtyjmnnyyyxltzcsxqclhzxl"
"wyxzhnnlrxkxjcdyhlbrlmbrdlaxksnlljlyxxlynrylcjtgncmtlzllcyzlpzpzyawnjjfybdyyzsepckzzqdqpbpsjpdyttbdb"
"bbyndycncpjmtmlrmfmmrwyfbsjgygsmdqqqztxmkqwgxllpjgzbqrdjjjfpkjkcxbljmswldtsjxldlppbxcwkcqqbfqbccajzg"
"mykbhyhhzykndqzybpjnspxthlfpnsygyjdbgxnhhjhzjhstrstldxskzysybmxjlxyslbzyslzxjhfybqnbylljqkygzmcyzzym"
"ccslnlhzhwfwyxzmwyxtynxjhbyymcysbmhysmydyshnyzchmjjmzcaahcbjbbhblytylsxsnxgjdhkxxtxxnbhnmlngsltxmrhn"
"lxqqxmzllyswqgdlbjhdcgjyqyymhwfmjybbbyjyjwjmdpwhxqldyapdfxxbcgjspckrssyzjmslbzzjfljjjlgxzgyxyxlszqkx"
"bexyxhgcxbpndyhwectwwcjmbtxchxyqqllxflyxlljlssnwdbzcmyjclwswdczpchqekcqbwlcgydblqppqzqfnqdjhymmcxtxd"
"rmzwrhxcjzylqxdyynhyyhrslnrsywwjjymtltllgtqcjzyabtckzcjyccqlysqxalmzynywlwdnzxqdllqshgpjfjljnjabcqzd"
"jgthhsstnyjfbswzlxjxrhgldlzrlzqzgsllllzlymxxgdzhgbdphzpbrlwnjqbpfdwonnnhlypcnjccndmbcpbzzncyqxldomzb"
"lzwpdwyygdstthcsqsccrsssyslfybnntyjszdfndpdhtqzmbqlxlcmyffgtjjqwftmnpjwdnlbzcmmcngbdzlqlpnfhyymjylsd"
"chdcjwjcctljcldtljjcbddpndsszycndbjlggjzxsxnlycybjjxxcbylzcfzppgkcxqdzfztjjfjdjxzbnzyjqctyjwhdyczhym"
"djxttmpxsplzcdwslshxypzgtfmlcjtacbbmgdewycyzxdszjyhflystygwhkjyylsjcxgywjcbllcsnddbtzbsclyzczzssqdll"
"mjyyhfllqllxfdyhabxggnywyypllsdldllbjcyxjznlhljdxyyqytdlllbngpfdfbbqbzzmdpjhgclgmjjpgaehhbwcqxajhhhz"
"chxyphjaxhlphjpgpzjqcqzgjjzzgzdmqyybzzphyhybwhazyjhykfgdpfqsdlzmljxjpgalxzdaglmdgxmmzqwtxdxxpfdmmssy"
"mpfmdmmkxksyzyshdzkjsysmmzzzmdydyzzczxbmlstmdyemxckjmztyymzmzzmsshhdccjewxxkljsthwlsqlyjzllsjssdppmh"
"nlgjczyhmxxhgncjmdhxtkgrmxfwmckmwkdcksxqmmmszzydkmsclcmpcjmhrpxqpzdsslcxkyxtwlkjyahzjgzjwcjnxyhmmbml"
"gjxmhlmlgmxctkzmjlyscjsyszhsyjzjcdajzhbsdqjzgwtkqxfkdmsdjlfmnhkzqkjfeypzyszcdpynffmzqykttdzzefmzlbnp"
"plplpbpszalltnlkckqzkgenjlwalkxydpxnhsxqnwqnkxqclhyxxmlnccwlymqyckynnlcjnszkpyzkcqzqljbdmdjhlasqlbyd"
"wqlwdgbqcryddztjybkbwszdxdtnpjdtcnqnfxqqmgnseclstbhpwslctxxlpwydzklnqgzcqapllkqcylbqmqczqcnjslqzdjxl"
"ddhpzqdljjxzqdjyzhhzlkcjqdwjppypqakjyrmpzbnmcxkllzllfqpylllmbsglzysslrsysqtmxyxzqzbscnysyztffmzzsmzq"
"hzssccmlyxwtpzgxzjgzgsjzgkddhtqggzllbjdzlsbzhyxyzhzfywxytymsdnzzyjgtcmtnxqyxjscxhslnndlrytzlryylxqht"
"xsrtzcgyxbnqqzfhykmzjbzymkbpnlyzpblmcnqyzzzsjztjctzhhyzzjrdyzhnfxklfzslkgjtctssyllgzrzbbjzzklpkbczys"
"nnyxbjfbnjzzxcdwlzyjxzzdjjgggrsnjkmsmzjlsjywqsnyhqjsxpjztnlsnshrnynjtwchglbnrjlzxwjqxqkysjycztlqzybb"
"ybyzjqdwgyzcytjcjxckcwdkkzxsnkdnywwyyjqyytlytdjlxwkcjnklccpzcqqdzzqlcsfqchqqgssmjzzllbjjzysjhtsjdysj"
"qjpdszcdchjkjzzlpycgmzndjxbsjzzsyzyhgxcpbjydssxdzncglqmbtsfcbfdzdlznfgfjgfsmpnjqlnblgqcyyxbqgdjjqsrf"
"kztjdhczklbsdzcfytplljgjhtxzcsszzxstjygkgckgynqxjplzbbbgcgyjzgczqszlbjlsjfzgkqqjcgycjbzqtldxrjnbsxxp"
"zshszycfwdsjjhxmfczpfzhqhqmqnknlyhtycgfrzgnqxcgpdlbzcsczqlljblhbdcypscppdymzzxgyhckcpzjgslzlnscnsldl"
"xbmsdlddfjmkdqdhslzxlsznpqpgjdlybdskgqlbzlnlkyyhzttmcjnqtzzfszqktlljtyyllnllqyzqlbdzlslyyzxmdfszsnxl"
"xznczqnbbwskrfbcylctnblgjpmczzlstlxshtzcyzlzbnfmqnlxflcjlyljqcbclzjgnsstbrmhxzhjzclxfnbgxgtqncztmsfz"
"kjmssncljkbhszjntnlzdntlmmjxgzjyjczxyhyhwrwwqnztnfjscpyshzjfyrdjsfscjzbjfzqzchzlxfxsbzqlzsgyftzdcszx"
"zjbjpszkjrhxjzcgbjkhcggtxkjqglxbxfgtrtylxqxhdtsjxhjzjjcmzlcqsbtxwqgxtxxhxftsdkfjhzyjfjxnzldlllcqsqqz"
"qwqxswqtwgwbzcgcllqzbclmqjtzgzyzxljfrmyzflxnsnxxjkxrmjdzdmmyxbsqbhgzmwfwygmjlzbyytgzyccdjyzxsngnyjyz"
"nbgpzjcqsyxsxrtfyzgrhztxszzthcbfclsyxzlzqmzlmplmxzjssfsbysmzqhxxnxrxhqzzzsslyflczjrcrxhhzxqndshxsjjh"
"qcjjbcynsysxjbqjpxzqplmlxzkyxlxcnlcycxxzzlxdlllmjyhzxhyjwkjrwyhcpsgnrzlfzwfzznsxgxflzsxzzzbfcsyjdbrj"
"krdhhjxjljjtgxjxxstjtjxlyxqfcsgswmsbctlqzzwlzzkxjmltmjyhsddbxgzhdlbmyjfrzfcgclyjbpmlysmsxlszjqqhjzfx"
"gfqfqbphngyyqxgztnqwyltlgwgwwhnlfmfgzjmgmgbgtjflyzzgzyzaflsspmlbflcwbjztljjmzlpjjlymqtmyyyfbgygqzgly"
"zdxqyxrqqqhsxyyqxygjtyxfsfsllgnqcygycwfhcccfxpylypllzqxxxxxqqhhsshjzcftsczjxspzwhhhhhapylqnlpqafyhxd"
"ylnkmzqgggddesrenzltzgchyppcsqjjhclljtolnjpzljlhymhezdydsqycddhgznndzclzywllznteydgnlhslpjjbdgwxpcnn"
"tycklkclwkllcasstknzdnnjttlyyzssysszzryljqkcgdhhyrxrzydgrgcwcgzqffbppjfzynakrgywyjpqxxfkjtszzxswzddf"
"bbqtbgtzkznpzfpzxzpjszbmqhkyyxyldkljnypkyghgdzjxxeaxpnznctzcmxcxmmjxnkszqnmnlwbwwqjjyhclstmcsxnjcxxt"
"pcnfdtnnpglllzcjlspblpgjcdtnjjlyarscffjfqwdpgzdwmrzzcgodaxnssnyzrestyjwjyjdbcfxnmwttbqlwstszgybljpxg"
"lbnclgpcbjftmxzljylzxcltpnclcgxtfzjshcrxsfysgdkntlbyjcyjllstgqcbxnhzxbxklylhzlqzlnzcqwgzlgzjncjgcmnz"
"zgjdzxtzjxycyycxxjyyxjjxsssjstsstdppghtcsxwzdcsynptfbchfbblzjclzzdbxgcjlhpxnfzflsyltnwbmnjhszbmdnbcy"
"sccldnycndqlyjjhmqllcsgljjsyfpyyccyltjantjjpwycmmgqyysxdxqmzhszxbftwwzqswqrfkjlzjqqyfbrxjhhfwjgzyqac"
"myfrhcyybynwlpexcczsyyrlttdmqlrkmpbgmyyjprkznbbsqyxbhyzdjdnghpmfsgbwfzmfqmmbzmzdcgjlnnnxyqgmlrygqccy"
"xzlwdkcjcggmcjjfyzzjhycfrrcmtznzxhkqgdjxccjeascrjthpljlrzdjrbcqhjdnrhylyqjsymhzydwcdfryhbbydtssccwbx"
"glpzmlzjdqsscfjmmxjcxjytycghycjwynsxlfemwjnmkllswtxhyyyncmmcyjdqdjzglljwjnkhpzggflccsczmcbltbhbqjxqd"
"jpdjztghglfjawbzyzjltstdhjhctcbchflqmpwdshyytqwcnntjtlnnmnndyyyxsqkxwyyflxxnzwcxypmaelyhgjwzzjbrxxaq"
"jfllpfhhhytzzxsgqjmhspgdzqwbwpjhzjdyjcqwxkthxsqlzyymysdzgnqckknjlwpnsyscsyzlnmhqsyljxbcxtlhzqzpcycyk"
"pppnsxfyzjjrcemhszmnxlxglrwgcstlrsxbygbzgnxcnlnjlclynymdxwtzpalcxpqjcjwtcyyjlblxbzlqmyljbghdslssdmxm"
"bdczsxyhamlczcpjmcnhjyjnsykchskqmczqdllkablwjqsfmocdxjrrlyqchjmybyqlrhetfjzfrfksryxfjdwtsxxywsqjysly"
"xwjhsdlxyyxhbhawhwjcxlmyljcsqlkydttxbzslfdxgxsjkhsxxybssxdpwncmrptqzczenygcxqfjxkjbdmljzmqqxnoxslyxx"
"lylljdzptymhbfsttqqwlhsgynlzzalzxclhtwrrqhlstmypyxjjxmnsjnnbryxyjllyqyltwylqyfmlkljdnlltfzwkzhljmlhl"
"jnljnnlqxylmbhhlnlzxqchxcfxxlhyhjjgbyzzkbxscqdjqdsndzsygzhhmgsxcsymxfepcqwwrbpyyjqryqcyjhqqzyhmwffhg"
"zfrjfcdbxntqyzpcyhhjlfrzgpbxzdbbgrqstlgdgylcqmgchhmfywlzyxkjlypjhsywmqqggzmnzjnsqxlqsyjtcbehsxfszfxz"
"wfllbcyyjdytdthwzsfjmqqyjlmqsxlldttkghybfpwdyysqqrnqwlgwdebzwcyygcnlkjxtmxmyjsxhybrwfymwfrxyymxysctz"
"ztfykmldhqdlgyjnlcryjtlpsxxxywlsbrrjwxhqybhtydnhhxmmywytycnnmnssccdalwztcpqpyjllqzyjswjwzzmmglmxclmx"
"nzmxmzsqtzppjqblpgxjzhfljjhycjsrxwcxsncdlxsyjdcqzxslqyclzxlzzxmxqrjmhrhzjbhmfljlmlclqnldxzlllfyprgjy"
"nxcqqdcmqjzzxhnpnxzmemmsxykynlxsxtljxyhwdcwdzhqyybgybcyscfgfsjnzdrzzxqxrzrqjjymcanhrjtldbpyzbstjhxxz"
"ypbdwfgzzrpymnnkxcqbyxnbnfyckrjjcmjegrzgyclnnzdnkknsjkcljspgyyclqqjybzssqlllkjftbgtylcccdblsppfylgyd"
"tzjqjzgkntsfcxbdkdxxhybbfytyhbclnnytgdhryrnjsbtcsnyjqhklllzslydxxwbcjqsbxnpjzjzjdzfbxxbrmladhcsnclbj"
"dstblprznswsbxbcllxxlzdnzsjpynyxxyftnnfbhjjjgbygjpmmmmsszljmtlyzjxswxtyledqpjmpgqzjgdjlqjwjqllsdgjgy"
"gmscljjxdtygjqjjjcjzcjgdzdshqgzjggcjhqxsnjlzzbxhsgzxcxyljxyxyydfqqjhjfxdhctxjyrxysqtjxyefyyssyxjxncy"
"zxfxcsxszxyyschshxzzzgzzzgfjdldylnpzgsjaztyqzpbxcbdztzczyxxyhhscjshcggqhjhgxhsctmzmehyxgebtclzkkwytj"
"zrslekestdbcyhqqsayxcjxwwgsphjszsdncsjkqcxswxfctynydpccczjqtcwjqjzzzqzljzhlsbhpydxpsxshhezdxfptjqyzc"
"xhyaxncfzyyhxgnqmywntzsjbnhhgymxmxqcnssbcqsjyxxtyyhybcqlmmszmjzzllcogxzaajzyhjmchhcxzsxsdznleyjjzjbh"
"zwjzsqtzpsxzzdsqjjjlnyazphhyysrnqzthzhnyjyjhdzxzlswclybzyecwcycrylchzhzydzydyjdfrjjhtrsqtxyxjrjhojyn"
"xelxsfsfjzghpzsxzszdzcqzbyyklsgsjhczshdgqgxyzgxchxzjwyqwgyhksseqzzndzfkwyssdclzstsymcdhjxxyweyxczayd"
"mpxmdsxybsqmjmzjmtjqlpjyqzcgqhyjhhhqxhlhdldjqcfdwbsxfzzyyschtytyjbhecxhjkgqfxbhyzjfxhwhbdzfyzbchpnpg"
"dydmsxhkhhmamlnbyjtmpxejmcthqbzyfcgtyhwphftgzzezsbzegpbmdskftycmhbllhgpzjxzjgzjyxzsbbqsczzlzscstpgxm"
"jsfdcczjzdjxsybzlfcjsazfgszlwbczzzbyztzynswyjgxzbdsynxlgzbzfygczxbzhzftpbgzgejbstgkdmfhyzzjhzllzzgjq"
"zlsfdjsscbzgpdlfzfzszyzyzsygcxsnxxchczxtzzljfzgqsqqxcjqccccdjcdszzyqjccgxztdlgscxzsyjjqtcclqdqztqchq"
"qyzynzzzpbkhdjfcjfztypqyqttynlmbdktjcpqzjdzfpjsbnjlgyjdxjdcqkzgqkxclbzjtcjdqbxdjjjstcxnxbxqmslyjcxnt"
"jqwwcjjnjjlllhjcwqtbzqqczczpzzdzyddcyzdzccjgtjfzdprntctjdcxtqzdtjnplzbcllctdsxkjzqdmzlbznbtjdcxfczdb"
"czjjltqqpldckztbbzjcqdcjwynllzlzccdwllxwzlxrxntqjczxkjlsgdnqtddglnlajjtnnynkqlldzntdnycygjwyxdxfrsqs"
"tcdenqmrrqzhhqhdldazfkapbggpzrebzzykyqspeqjjglkqzzzjlysyhyzwfqznlzzlzhwcgkypqgnpgblplrrjyxcccgyhsfzf"
"wbzywtgzxyljczwhncjzplfflgskhyjdeyxhlpllllcygxdrzelrhgklzzyhzlyqszzjzqljzflnbhgwlczcfjwspyxzlzlxgccp"
"zbllcxbbbbnbbcbbcrnnzccnrbbnnldcgqyyqxygmqzwnzytyjhyfwtehznjywlccntzyjjcdedpwdztstnjhtymbjnyjzlxtsst"
"phndjxxbyxqtzqddtjtdyztgwscszqflshlnzbcjbhdlyzjyckwtydylbnydsdsycctyszyyebgexhqddwnygyclxtdcystqnygz"
"ascsszzdzlcclzrqxyywljsbymxshzdembbllyyllytdqyshymrqnkfkbfxnnsbychxbwjyhtqbpbsbwdzylkgzskyghqzjxhxjx"
"gnljkzlyycdxlfwfghljgjybxblybxqpqgntzplncybxdjyqydymrbeyjyyhkxxstmxrczzjwxyhybmcflyzhqyzfwxdbxbcwzms"
"lpdmyckfmzklzcyqycclhxfzlydqzpzygyjyzmdxtzfnnyttqtzhgsfcdmlccytzxjcytjmkslpzhysnwllytpzctzccktxdhxxt"
"qcyfksmqccyyazhtjplylzlyjbjxtfnyljyynrxcylmmnxjsmybcsysslzylljjgyldzdlqhfzzblfndsqkczfyhhgqmjdsxyctt"
"xnqnjpyybfcjtyyfbnxejdgyqbjrcnfyyqpghyjsyzngrhtknlnndzntsmgklbygbpyszbydjzsstjztsxzbhbscsbzczptqfzlq"
"flypybbjgszmnxdjmtsyskkbjtxhjcegbsmjyjzcstmljyxrczqscxxqpyzhmkyxxxjcljyrmyygadyskqlnadhrskqxzxztcggz"
"dlmlwxybwsyctbhjhcfcwzsxwwtgzlxqshnyczjxemplsrcgltnzntlzjcyjgdtclglbllqpjmzpapxyzlaktkdwczzbncctdqqz"
"qyjgmcdxltgcszlmlhbglkznnwzndxnhlnmkydlgxdtwcfrjerctzhydxykxhwfzcqshknmqqhzhhymjdjskhxzjzbzzxympajnm"
"ctbxlsxlzynwrtsqgscbptbsgzwyhtlkssswhzzlyytnxjgmjrnsnnnnlskztxgxlsammlbwldqhylakqcqctmycfjbslxclzjcl"
"xxknbnnzlhjphqplsxsckslnhpsfqcytxjjzljldtzjjzdlydjntptnndskjfsljhylzqqzlbthydgdjfdbyadxdzhzjnthqbykn"
"xjjqczmlljzkspldsclbblnnlelxjlbjycxjxgcnlcqplzlznjtsljgyzdzpltqcssfdmnycxgbtjdcznbgbqyqjwgkfhtnbyqzq"
"gbkpbbyzmtjdytblsqmbsxtbnpdxklemyycjynzdtldykzzxtdxhqshygmzsjycctayrzlpwltlkxslzcggexclfxlkjrtlqjaqz"
"ncmbqdkkcxglczjzxjhptdjjmzqykqsecqzdshhadmlzfmmzbgntjnnlhbyjbrbtmlbyjdzxlcjlpldlpcqdhlhzlycblcxccjad"
"qlmzmmsshmybhbnkkbhrsxxjmxmdznnpklbbrhgghfchgmnklltsyyycqlcskymyehywxnxqywbawykqldnntndkhqcgdqktgpkx"
"hcpdhtwnmssyhbwcrwxhjmkmzngwtmlkfghkjyldyycxwhyyclqhkqhtdqkhffldxqwytyydesbpkyrzpjfyyzjceqdzzdlattpb"
"fjllcxdlmjsdxegwgsjqxcfbssszpdyzcxznyxppzydlyjccpltxlnxyzyrscyyytylwwndsahjsygyhgywwaxtjzdaxysrltdps"
"syxfnejdxyzhlxlllzhzsjnyqyqyxyjghzgjcyjchzlycdshhsgczyjscllnxzjjyyxnfsmwfpyllyllabmddhwzxjmcxztzpmlq"
"chsfwzynctlndywlslxhymmylmbwwkyxyaddxylldjpybpwnxjmmmllhafdllaflbnhhbqqjqzjcqjjdjtffkmmmpythygdrjrdd"
"wrqjxnbysrmzdbyytbjhpymyjtjxaahggdqtmystqxkbtzbkjlxrbyqqhxmjjbdjntgtbxpgbktlgqxjjjcdhxqdwjlwrfmjgwqh"
"cnrxswgbtgygbwhswdwrfhwytjjxxxjyzyslphyypyyxhydqpxshxyxgskqhywbdddpplcjlhqeewjgsyykdpplfjthkjltcyjhh"
"jttpltzzcdlyhqkcjqysteeyhkyzyxxyysddjkllpymqyhqgxqhzrhbxpllnqydqhxsxxwgdqbshyllpjjjthyjkyphthyyktyez"
"yenmdshlzrpqfbnfxzbsftlgxsjbswyysksflxlpplbbblnsfbfyzbsjssylpbbffffsscjdstjsxtryjcyffsyzyzbjtlctsbsd"
"hrtjjbytcxyyeylycbnebjdsysyhgsjzbxbytfzwgenhhhthjhhxfwgcstbgxklstyymtmbyxjskzscdyjrcythxzfhmymcxlzns"
"djtxtxrycfyjsbsdyerxhljxbbdeynjghxgckgscymblxjmsznskgxfbnbbthfjyafxwxfbxmyfhdttcxzzpxrsywzdlybbktyqw"
"qjbzypzjznjpzjlztfysbttslmptzrtdxqsjehbnylndxljsqmlhtxtjecxalzzspktlzkqqyfsyjywpcpqfhjhytqxzkrsgtksq"
"czlptxcdyyzsslzslxlzmacpcqbzyxhbsxlzdltztjtylzjyytbzypltxjsjxhlbmytxcqrblzssfjzztnjytxmyjhlhpblcyxqj"
"qqkzzscpzkswalqsplczzjsxgwwwygyatjbbctdkhqhkgtgpbkqyslbxbbckbmllndzstbklggqkqlzbkktfxrmdkbftpzfrtppm"
"ferqnxgjpzsstlbztpszqzsjdhljqlzbpmsmmsxlqqnhknblrddnhxdkddjcyyljfqgzlgsygmjqjkhbpmxyxlytqwlwjcpbmjxc"
"yzydrjbhtdjyeqshtmgsfyplwhlzffnynnhxqhpltbqpfbjwjdbygpnxtbfzjgnnntjshxeawtzylltyqbwjpgxghnnkndjtmszs"
"qynzggnwqtfhclssgmnnnnynzqqxncjdqgzdlfnykljcjllzlmzznnnnsshthxjlzjbbhqjwwycrdhlyqqjbeyfsjhthnrnwjhwp"
"slmssgzttygrqqwrnlalhmjtqjsmxqbjjzjqzyzkxbjqxbjxshzssfglxmxnxfghkzszggslcnnarjxhnlllmzxelglxydjytlfb"
"kbpnlyzfbbhptgjkwetzhkjjxzxxglljlstgshjjyqlqzfkcgnndjsszfdbctwwseqfhqjbsaqtgypjlbxbmmywxgslzhglsgnyf"
"ljbyfdjfngsfmbyzhqffwjsyfyjjphzbyyzffwotjnlmftwlbzgyzqxcdjygzyyryzynyzwegazyhjjlzrthlrmgrjxzclnnnljj"
"yhtbwjybxxbxjjtjteekhwslnnlbsfazpqqbdlqjjtyyqlyzkdksqjnejzldqcgjqnnjsncmrfqthtejmfctyhypymhydmjncfgy"
"yxwshctxrljgjzhzcyyyjltkttntmjlzclzzayyoczlrlbszywjytsjyhbyshfjlykjxxtmzyyltxxypslqyjzyzyypnhmymdyyl"
"blhlsyygqllnjjymsoycbzgdlyxylcqyxtszegxhzglhwbljheyxtwqmakbpqcgyshhegqcmwyywljyjhyyzlljjylhzyhmgsljl"
"jxcjjyclycjbcpzjzjmmwlcjlnqljjjlxyjmlszljqlycmmgcfmmfpqqmfxlqmcffqmmmmhnznfhhjgtthxkhslnchhyqzxtmmqd"
"cydyxyqmyqylddcyaytazdcymdydlzfffmmycqcwzzmabtbyctdmndzggdftypcgqyttssffwbdttqssystwnjhjytsxxylbyyhh"
"whxgzxwznnqzjzjjqjccchykxbzszcnjtllcqxynjnckycynccqnxyewyczdcjycchyjlbtzyycqwlpgpyllgktltlgkgqbgychj"
"xy";

char pinyinFirstLet(unsigned short hanzi) {
	int index = hanzi - HANZI_START;
	if (index >= 0 && index <= HANZI_COUNT) {
		return firstLetterArray[index];
	} else {
		return '#';
	}
}

@implementation EaseChineseToPinyin

+ (NSString *) pinyinFromChineseString:(NSString *)string {
	if(!string || ![string length]) return nil;
	
	NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding( kCFStringEncodingGB_18030_2000);
	NSData *gb2312_data = [string dataUsingEncoding:enc];
	
    unsigned char ucHigh, ucLow;
    int nCode;
    NSString *strValue = @"";
	int iLen = (int)[gb2312_data length];
	char *gb2312_string = (char *)[gb2312_data bytes];
    for (int i = 0; i < iLen; i++) {
        if ((unsigned char)gb2312_string[i] < 0x80 ) {
			strValue = [strValue stringByAppendingFormat:@"%c", gb2312_string[i] > 95 ? gb2312_string[i] - 32 : gb2312_string[i]];
            continue;
		}
		
        ucHigh = (unsigned char)gb2312_string[i];
        ucLow  = (unsigned char)gb2312_string[i + 1];
        if ( ucHigh < 0xa1 || ucLow < 0xa1)
            continue;
        else
            nCode = (ucHigh - 0xa0) * 100 + ucLow - 0xa0;
		
		NSString *strRes = FindLetter(nCode);
		strValue = [strValue stringByAppendingString:strRes];
        i++;
    }	
	return [[NSString alloc] initWithString:strValue] ;
    ;
}

+ (char) sortSectionTitle:(NSString *)string {
	int cLetter = 0;
	if( !string || 0 == [string length] )
		cLetter = '#';
	else {	
		if(([string characterAtIndex:0] > 64 && [string characterAtIndex:0] < 91) || 
		   ([string characterAtIndex:0] > 96 && [string characterAtIndex:0] < 123) ) {
			cLetter = [string characterAtIndex:0];
		} else
			cLetter = pinyinFirstLet((unsigned short)[string characterAtIndex:0]);
		
		if(cLetter > 95)
			cLetter -= 32;
	}	
	return cLetter;
}

@end