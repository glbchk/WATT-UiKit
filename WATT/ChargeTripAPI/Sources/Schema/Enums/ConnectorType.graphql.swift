// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

/// The socket or plug standard of the charging point.
public enum ConnectorType: String, EnumType {
  /// The connector type is CHAdeMO, DC.
  case chademo = "CHADEMO"
  /// Standard/domestic household, type "A", NEMA 1-15, 2 pins.
  case domesticA = "DOMESTIC_A"
  /// Standard/domestic household, type "B", NEMA 5-15, 3 pins.
  case domesticB = "DOMESTIC_B"
  /// Standard/domestic household, type "C", CEE 7/17, 2 pins.
  case domesticC = "DOMESTIC_C"
  /// Standard/domestic household, type "D", 3 pins.
  case domesticD = "DOMESTIC_D"
  /// Standard/domestic household, type "E", CEE 7/5 3 pins.
  case domesticE = "DOMESTIC_E"
  /// Standard/domestic household, type "F", CEE 7/4, Schuko, 3 pins.
  case domesticF = "DOMESTIC_F"
  /// Standard/domestic household, type "G", BS 1363, Commonwealth, 3 pins.
  case domesticG = "DOMESTIC_G"
  /// Standard/domestic household, type "H", SI-32, 3 pins.
  case domesticH = "DOMESTIC_H"
  /// Standard/domestic household, type "I", AS 3112, 3 pins.
  case domesticI = "DOMESTIC_I"
  /// Standard/domestic household, type "J", SEV 1011, 3 pins.
  case domesticJ = "DOMESTIC_J"
  /// Standard/domestic household, type "K", DS 60884-2-D1, 3 pins.
  case domesticK = "DOMESTIC_K"
  /// Standard/domestic household, type "L", CEI 23-16-VII, 3 pins.
  case domesticL = "DOMESTIC_L"
  /// Standard/Domestic household, type "M", BS 546, 3 pins.
  case domesticM = "DOMESTIC_M"
  /// Standard/Domestic household, type "N", NBR 14136, 3 pins.
  case domesticN = "DOMESTIC_N"
  /// Standard/Domestic household, type "O", TIS 166-2549, 3 pins.
  case domesticO = "DOMESTIC_O"
  /// IEC 60309-2 Industrial connector single phase 16 amperes (usually blue).
  case iec603092Single16 = "IEC_60309_2_single_16"
  /// IEC 60309-2 Industrial connector three phase 16 amperes (usually red).
  case iec603092Three16 = "IEC_60309_2_three_16"
  /// IEC 60309-2 Industrial connector three phase 32 amperes (usually red).
  case iec603092Three32 = "IEC_60309_2_three_32"
  /// IEC 60309-2 Industrial connector three phase 64 amperes (usually red).
  case iec603092Three64 = "IEC_60309_2_three_64"
  /// IEC 62196 Type 1 "SAE J1772".
  case iec62196T1 = "IEC_62196_T1"
  /// Combo Type 1 based, DC.
  case iec62196T1Combo = "IEC_62196_T1_COMBO"
  /// IEC 62196 Type 2 "Mennekes".
  case iec62196T2 = "IEC_62196_T2"
  /// Combo Type 2 based, DC.
  case iec62196T2Combo = "IEC_62196_T2_COMBO"
  /// IEC 62196 Type 3A.
  case iec62196T3A = "IEC_62196_T3A"
  /// IEC 62196 Type 3C "Scame".
  case iec62196T3C = "IEC_62196_T3C"
  /// On-board bottom-up-pantograph typically for bus charging.
  case pantographBottomUp = "PANTOGRAPH_BOTTOM_UP"
  /// Off-board top-down-pantograph typically for bus charging.
  case pantographTopDown = "PANTOGRAPH_TOP_DOWN"
  /// Tesla connector "Roadster"-type (round, 4 pins).
  case teslaR = "TESLA_R"
  /// Tesla connector "Model-S"-type (oval, 5 pins).
  case teslaS = "TESLA_S"
  /// The connector type is GB_T (Chinese standard), DC.
  case gbT = "GB_T"
  /// The ChaoJi connector. The new generation charging connector, harmonized between CHAdeMO and GB/T. DC.
  case chaoji = "CHAOJI"
  /// The connector type is NEMA 5-20, 3 pins.
  case nema520 = "NEMA_5_20"
  /// The connector type is NEMA 6-30, 3 pins.
  case nema630 = "NEMA_6_30"
  /// The connector type is NEMA 6-50, 3 pins.
  case nema650 = "NEMA_6_50"
  /// The connector type is NEMA 10-30, 3 pins.
  case nema1030 = "NEMA_10_30"
  /// The connector type is NEMA 10-50, 3 pins.
  case nema1050 = "NEMA_10_50"
  /// The connector type is NEMA 14-30, 3 pins, rating of 30 A.
  case nema1430 = "NEMA_14_30"
  /// The connector type is NEMA 14-50, 3 pins, rating of 50 A.
  case nema1450 = "NEMA_14_50"
}
