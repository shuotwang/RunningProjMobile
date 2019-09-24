//
//  FindPeak.swift
//  PureformiPad
//
//  Created by Joe Lao on 17/5/2018.
//  Copyright © 2018 Zhi-I Yeung. All rights reserved.
//

import Foundation
import Accelerate
import Surge

class FindPeak {
    
    enum Args {
        case MinPeakProminence
        case MinPeakHeight
        case MinPeakDistance
    }
    
    static func getPropulsion(AP:[Double], tibShocks:[Double], speed:Double, mass:Double) -> Double {
        let inputOffset: [Float] = [1.00015417761224,3.001578125,7,536.336874430339]
        let inputGain: [Float] = [0.200453327507622,0.128284631526199,0.222222222222222,0.00769102017704939]
        let inputYMin: Float = -1
        
        let layer1Bias: [Float] = [-1.5806649669871786212,0.09900873809710723783,0.32318391032304372157,-0.71894022630418807918,0.63807724733291115715,0.71498764903400680026,1.8159257780740396537,1.018363407497634876,-5.4957594853430951076,-1.8855857132034634649]
        let layer1Weight: [Float] = [
            0.019289635676070501086,0.50613501646984615512,0.93677806332996982341,-0.79835934948244113851,
            0.16630373670436152111,-0.0061544813076786593006,-0.35373978601193989402,-1.3241434817085333542,
            -0.21384792750835959763,0.069483674841254713939,0.22836713751750617463,2.4808828368207058723,
            0.49371651074857736408,0.12478804830293652173,-2.745541771499902417,1.3685145594796754853,
            0.17087711369630886882,0.20184370461567857635,-0.43962168585212690886,-0.64642509934466807486,
            -0.15456197883371669555,-0.1544568404772421466,2.0415196231897110302,-1.2415545839504615877,
            0.12389271211404040418,4.5734204269182230362,6.6246056615021400304,-0.42194078216576968998,
            -0.23651770335444999294,2.3393577596790411377,1.711109676005887037,-0.78519177813546137124,
            0.27637732966125255762,0.25538357685686929877,-0.053603104493748512938,-5.8280547436940945971,
            -0.25927841064539569604,0.34845700335240120671,0.014277837169507230988,3.0224068060234294819
        ]
        
        let layer2Bias: [Float] = [1.7866944520243481787]
        let layer2Weight: [Float] = [1.2795689718782734534,10.224447417470660326,5.7528059459248446217,2.2949992214870880147,-3.9034271508278206575,3.4618909689720589462,-0.1719546694855876301,0.39703861152373742804,-0.7197649101247424186,2.4107211168510396249]
        
        let outputYMin: Float = -1
        let outputGain: Float = 0.00864007999580379
        let outputOffset: Float = 40.028990446211
        
        let data = NeuralNetwork.NetworkData(inputOffset: inputOffset,
                                             inputGain: inputGain,
                                             inputYMin: inputYMin,
                                             layer1Bias: layer1Bias,
                                             layer1Weight: layer1Weight,
                                             layer2Bias: layer2Bias,
                                             layer2Weight: layer2Weight,
                                             outputOffset: outputOffset,
                                             outputGain: outputGain,
                                             outputYMin: outputYMin)
        let network = NeuralNetwork(data: data)
        
        var predicted = [Float]()
        for i in 0..<min(tibShocks.count, AP.count) {
            let input: [Float] = [Float(AP[i]), Float(tibShocks[i]), Float(speed), Float(mass*9.81)]
            predicted.append(network.predict(input: input))
        }
        let result = Surge.sum(predicted) / Float(predicted.count)
        
        return Double(result)
    }
    
    static func getBrakingForce(AP:[Double], tibShocks:[Double], speed:Double, mass:Double) -> Double {
        let inputOffset: [Float] = [2.00002966308594,3.001578125,7,536.336874430339]
        let inputGain: [Float] = [0.130431879546505,0.128284631526199,0.222222222222222,0.00769102017704939]
        let inputYMin: Float = -1
        
        let layer1Bias: [Float] = [0.81183748752325701759,-13.634667866227408339,3.6766596487822877926,-1.8316279382925215735,3.7633771472152259818,-1.5896806896000426068,-0.93315026527111455401,-4.8250211408726286777,1.2812589430228698006,3.6622643510207919526]
        let layer1Weight: [Float] = [
            -0.41019317743639915896,0.15082296493699801077,1.6497005830270508042,2.4907179149003408902,
            -1.3800393142809816993,-0.92030902929500646437,0.27627177604503011521,-18.228942001641939896,
            0.14449206359656799337,-0.00024980969905041741207,5.0877100269046753311,0.16583062109591986677,
            -0.041582078043183381966,-4.5127849612457380246,3.6664992594997958264,-0.66601532652623507413,
            0.2621326839955293031,0.1572894387715661757,-1.6141853047657217513,-18.010785919580193593,
            -0.78732482151987648322,-4.8424704327060110742,2.8688536367328008048,-1.0832514378854918302,
            -0.4354954044858522777,0.098702078143456009607,5.300532310515003509,0.29909420729087177193,
            4.1161380602294297404,-0.40434922974875214807,5.8221707148350700933,-17.300734922752969425,
            -0.61529728698188401737,0.23293705481358317755,2.7422018030188866078,3.8453271869059011401,
            1.80008520165689756,-0.38087381828567612452,5.719872049979373152,-1.90068709955193893
        ]
        
        let layer2Bias: [Float] = [0.16837612235995746968]
        let layer2Weight: [Float] = [-1.9279412744807571389,-0.34531811785869148679,0.31776022039635531957,0.11946862869922658668,-0.40828502421411916323,-0.12574813270673426691,0.27754890970958745466,0.088010374974567373574,1.3940608416285209525,-0.16025239787419626181]
        
        let outputYMin: Float = -1
        let outputGain: Float = 0.006641556199096
        let outputOffset: Float = 48.2788220729938
        
        let data = NeuralNetwork.NetworkData(inputOffset: inputOffset,
                                             inputGain: inputGain,
                                             inputYMin: inputYMin,
                                             layer1Bias: layer1Bias,
                                             layer1Weight: layer1Weight,
                                             layer2Bias: layer2Bias,
                                             layer2Weight: layer2Weight,
                                             outputOffset: outputOffset,
                                             outputGain: outputGain,
                                             outputYMin: outputYMin)
        let network = NeuralNetwork(data: data)
        
        var predicted = [Float]()
        for i in 0..<min(tibShocks.count, AP.count) {
            let input: [Float] = [Float(AP[i]),Float(tibShocks[i]), Float(speed), Float(mass*9.81)]
            predicted.append(network.predict(input: input))
        }
        let result = Surge.sum(predicted) / Float(predicted.count)
        
        return Double(result)
    }
    
    static func getCOMPower(tibShocks:[Double], speed:Double, mass:Double) -> Double {
        let inputOffset: [Float] = [4.00433177423039,7,536.336874430339]
        let inputGain: [Float] = [0.137102947975599,0.222222222222222,0.00769102017704939]
        let inputYMin: Float = -1
        
        let layer1Bias: [Float] = [-1.2346121483244152373,-9.3801594190613748481,1.6437500787370649125,-0.54305737466672832081,2.35100145876622868,2.9856199605485951309,1.1915307723124677342,2.6115137639029639693,0.89724606598560108228,-5.077478945703297164]
        let layer1Weight: [Float] = [
            0.18399749691979225275,2.0597343053811045799,-0.090880998447399913287,
            0.050431675929690174265,-0.44207173724711396057,-10.268408821407865261,
            -0.0023092851704069289158,-0.1426152139509825334,2.3168692289475383284,
            0.026432780849924675248,0.47531070190591112601,2.6085143966629500412,
            1.3977042959755507923,8.1874032512131211803,3.5056314809732729287,
            -0.029563454312010444686,-0.032843461409690404007,6.7727590436209137437,
            -0.03789914602688337214,0.90552350636757494851,2.4255498853258212755,
            1.80056518430189616,8.7108788795305489572,3.9248067902988084121,
            -0.036674719032194012802,0.48844494699132978699,0.97841190576639147647,
            0.023058218705088843331,0.13510538299047705757,-12.301820791352023221
        ]
        
        let layer2Bias: [Float] = [-3.2681979980279929343]
        let layer2Weight: [Float] = [0.37657386982486962257,2.8729639316751023337,8.399243140330238333,-1.1414312458401372208,1.1048866709865414748,-9.5600064462923146635,-1.296822838554254842,-1.0514234199589431729,4.7815887847241667075,-5.1786833310921629447]
        
        let outputYMin: Float = -1
        let outputGain: Float = 0.00323631700132921
        let outputOffset: Float = 122.599361353162
        
        let data = NeuralNetwork.NetworkData(inputOffset: inputOffset,
                                             inputGain: inputGain,
                                             inputYMin: inputYMin,
                                             layer1Bias: layer1Bias,
                                             layer1Weight: layer1Weight,
                                             layer2Bias: layer2Bias,
                                             layer2Weight: layer2Weight,
                                             outputOffset: outputOffset,
                                             outputGain: outputGain,
                                             outputYMin: outputYMin)
        let network = NeuralNetwork(data: data)
        
        var predicted = [Float]()
        for tibShock in tibShocks {
            let input: [Float] = [Float(tibShock), Float(speed), Float(mass*9.81)]
            predicted.append(network.predict(input: input))
        }
        let result = Surge.sum(predicted) / Float(predicted.count)
        
        return Double(result)
    }
    
    static func getEnergyLost(tibShocks:[Double], speed:Double, mass:Double) -> Double {
        let inputOffset: [Float] = [4.00433177423039,7,536.336874430339]
        let inputGain: [Float] = [0.137102947975599,0.222222222222222,0.00769102017704939]
        let inputYMin: Float = -1
        
        let layer1Bias: [Float] = [0.62942940469644115264,-7.2899084882848423916,3.2665066642861066981,-1.547065257245414216,6.2202587751236046998,-9.9817428788038142784,0.96369935167236986384,13.926944763103517033,1.0714509424226299483,-7.3101918579801843379]
        let layer1Weight: [Float] = [
            0.20802004406074281473,-1.6743759716047725838,-9.5616554178313020174,
            -0.72942153732088854667,3.1442063356240597116,-6.4283016133223966904,
            -2.1311393245254488527,4.5273296245816432304,6.0363704403373779073,
            -2.5526296104196157799,-18.539979578473779753,9.3605510947614405382,
            0.66009209640991961532,-2.9074338634706875517,5.3284499373305251879,
            -6.2301617157489710408,-6.7284610211920918843,0.9116392302319969998,
            -0.15118898494545593425,-0.28485776052318745322,1.2336051981108249187,
            -0.18985811643599984078,40.090881780939177759,-41.293099231467103039,
            0.10229718084724885585,-1.7798677283429986673,-14.054376584717699572,
            0.23465068468706504201,-19.699538176632277242,20.149102531284100337
        ]
        
        let layer2Bias: [Float] = [-0.0032479170294931252946]
        let layer2Weight: [Float] = [2.0434874790470067829,-5.0726829264274577724,-0.19091510808549796985,-0.089018017779848232496,-5.2434658785966163919,-0.027309530691088958892,0.63815370645739943889,-6.8271678234074029135,-2.1582852326311683377,-6.9908958701609131836]
        
        let outputYMin: Float = -1
        let outputGain: Float = 4.50882620159443
        let outputOffset: Float = -0.142429209619503
        
        let data = NeuralNetwork.NetworkData(inputOffset: inputOffset,
                                             inputGain: inputGain,
                                             inputYMin: inputYMin,
                                             layer1Bias: layer1Bias,
                                             layer1Weight: layer1Weight,
                                             layer2Bias: layer2Bias,
                                             layer2Weight: layer2Weight,
                                             outputOffset: outputOffset,
                                             outputGain: outputGain,
                                             outputYMin: outputYMin)
        let network = NeuralNetwork(data: data)
        
        var predicted = [Float]()
        for tibShock in tibShocks {
            let input: [Float] = [Float(tibShock), Float(speed), Float(mass*9.81)]
            predicted.append(network.predict(input: input))
        }
        let result = Surge.sum(predicted) / Float(predicted.count)
        
        return Double(result)
    }
    
    static func getLoadRate(tibShocks:[Double], speed:Double, mass:Double) -> Double {
        
        let inputOffset: [Float] = [4.00433177423039,7,536.336874430339]
        let inputGain: [Float] = [0.137102947975599,0.222222222222222,0.00769102017704939]
        let inputYMin: Float = -1
        
        let layer1Bias: [Float] = [0.38113272620519772493,3.8246434497047046008,2.3982160972939765564,-2.0530477328620171384,0.54166046636929188196,-2.5284763829231944321,-1.0232792792506313351,11.498777592186023355,-1.0765383565594506265,-3.5237200228895342313]
        let layer1Weight: [Float] = [
            -0.36846626700045143066,-0.49566619709917841829,-6.1990843962832498093,
            0.015868331059807876809,-0.052334603491218927018,4.32852024510865796,
            -1.0854413600456653821,0.60497973525088277746,1.7855221932773825966,
            4.519242990638293378,-3.9805199901286503206,-7.3165994942686847224,
            -0.3602753226639548445,-0.52350361544197687724,-7.9071281675257516497,
            0.022843926140453742896,0.13702750565984453401,-2.7772923773055251395,
            0.026268350826704561785,0.69854377069651041321,-0.73907983594043413778,
            0.26163254685322495652,0.59216153857531306226,23.720337806752382903,
            0.066020200129256162436,1.1065308346992863697,-0.6755593112887218199,
            -6.7634438495049531426,4.1885874437189638542,-12.38711873130647767
        ]
        
        let layer2Bias: [Float] = [-0.34754144692585137166]
        let layer2Weight: [Float] = [2.759552944479169323,-6.9398850850249269584,-0.39899922386153413578,0.11039918617985131077,-2.7742505338760028444,-11.290449161925458554,6.9315143180584684046,-0.57552099204522222387,-3.1011709471576751618,-0.12212335143972040397]
        
        let outputYMin: Float = -1
        let outputGain: Float = 0.0175162963335899
        let outputOffset: Float = 14.6578456168002
        
        let data = NeuralNetwork.NetworkData(inputOffset: inputOffset,
                                             inputGain: inputGain,
                                             inputYMin: inputYMin,
                                             layer1Bias: layer1Bias,
                                             layer1Weight: layer1Weight,
                                             layer2Bias: layer2Bias,
                                             layer2Weight: layer2Weight,
                                             outputOffset: outputOffset,
                                             outputGain: outputGain,
                                             outputYMin: outputYMin)
        let network = NeuralNetwork(data: data)
        
        var predicted = [Float]()
        for tibShock in tibShocks {
            let input: [Float] = [Float(tibShock), Float(speed), Float(mass*9.81)]
            predicted.append(network.predict(input: input))
        }
        let result = Surge.sum(predicted) / Float(predicted.count)
        
        return Double(result)
    }
    
    static func getVerticalOscillation(tibShocks:[Double], speed: Double, mass:Double) -> Double {
        let inputOffset: [Float] = [4.00433177423039,7,536.336874430339]
        let inputGain: [Float] = [0.137102947975599,0.222222222222222,0.00769102017704939]
        let inputYMin: Float = -1
        
        let layer1Bias: [Float] = [0.65582042527169637225,-0.26933264076908997042,0.53149845245004345706,0.054362297145350992056,0.14371010411987267252,0.1834274568794813931,-0.11195114095817376709,-1.3508948979095360965,-1.6318728500976089624,-0.037245985618156660091]
        let layer1Weight: [Float] = [
            0.10151192861113936261,-2.3833353694854935156,0.57031218912614756178,
            -0.40038435629991003806,-0.16974739768326913003,5.1038852501621772007,
            0.18423918540895486973,-1.4633137469283559184,1.5617679300433173761,
            -1.1149089191638681395,0.77026180686084577687,0.6044483931002224697,
            -1.3746900716637520112,1.1267881265073664832,1.3457416968836717341,
            2.3414252259502150721,-1.1148157967675800251,0.15032521953582736463,
            -0.16585642321362886742,-0.14791289496743317833,2.0516623430419378415,
            -0.76085931283389673929,-1.3536564825753303332,-0.57199102729105844034,
            -0.4170442475253654524,-1.111848899955407699,-0.41156403060484447742,
            -0.15981745705836333804,-0.086658065002320400216,-0.54591819769805249862
        ]
        
        let layer2Bias: [Float] = [-0.78223813789079854608]
        let layer2Weight: [Float] = [-0.44770609269976402445,1.154685769489952607,0.51790031323647089945,2.1936879529834905078,-1.2255883546447756682,0.46188205097441115132,-2.2260779517464790445,0.58979675661506614226,-1.3534329253237042945,-0.91371843897139903845]
        
        let outputYMin: Float = -1
        let outputGain: Float = 122.189864993226
        let outputOffset: Float = 0.0164535101877209
        
        let data = NeuralNetwork.NetworkData(inputOffset: inputOffset,
                                             inputGain: inputGain,
                                             inputYMin: inputYMin,
                                             layer1Bias: layer1Bias,
                                             layer1Weight: layer1Weight,
                                             layer2Bias: layer2Bias,
                                             layer2Weight: layer2Weight,
                                             outputOffset: outputOffset,
                                             outputGain: outputGain,
                                             outputYMin: outputYMin)
        let network = NeuralNetwork(data: data)
        network.constructNetwork()
        
        var predicted = [Float]()
        for tibShock in tibShocks {
            let input: [Float] = [Float(tibShock), Float(speed), Float(mass*9.81)]
            predicted.append(network.predict(input: input))
        }
        let result = Surge.sum(predicted) / Float(predicted.count)
        
        return Double(result)
    }
    
    static func getStiff(tibShocks:[Double], speed:Double, mass:Double) -> Double {
        let inputOffset: [Float] = [4.00433177423039,7,536.336874430339]
        let inputGain: [Float] = [0.137102947975599,0.222222222222222,0.00769102017704939]
        let inputYMin: Float = -1
        
        let layer1Bias: [Float] = [-4.339707749982044227,-5.6338111621460518208,-2.1376745958765517308,1.0011835390309362648,-0.17084345115535623516,0.45700470265502074474,-5.4959813225755755894,-2.2815111624562294246,-0.23390984640555126384,-5.048369499190212828]
        let layer1Weight: [Float] = [
            -0.051843605190507256741,0.16918195164537558339,-5.8740635932236857641,
            -0.22489964652622057573,-0.11687161780164712077,-7.6510815201235065075,
            0.27395030524785413117,-48.337455724133796764,-10.689235447125316369,
            -0.10579403812511417593,-0.36400762570090577919,-12.556638126620679685,
            -0.031802810725377606005,0.24942946534638521516,-0.63025706602257369759,
            -0.035002975288825052824,-0.023071141093170304676,-5.4407093887993829284,
            -0.11689657244770879085,0.057633294635800899619,-7.4193111144519390265,
            0.27039207590361069578,-53.100123647128384619,-11.613543170417656825,
            0.025338217050670283625,-0.19804736825795687949,-1.6979326302595592058,
            2.424765524521102833,-20.864087027979802969,-16.217074361153045459
        ]
        
        let layer2Bias: [Float] = [-0.1839955353888554912]
        let layer2Weight: [Float] = [7.688767279319932868,4.2878659886264651746,6.6891376318948232438,-1.2010406723765603143,-1.7247533852371594865,1.9599665214697370441,-11.232695049809278132,-6.66775139736343192,-1.1107908870138820667,-0.028587598326129039228]
        
        let outputYMin: Float = -1
        let outputGain: Float = 0.04197004884991
        let outputOffset: Float = 53.3684291937336
        
        let data = NeuralNetwork.NetworkData(inputOffset: inputOffset,
                                             inputGain: inputGain,
                                             inputYMin: inputYMin,
                                             layer1Bias: layer1Bias,
                                             layer1Weight: layer1Weight,
                                             layer2Bias: layer2Bias,
                                             layer2Weight: layer2Weight,
                                             outputOffset: outputOffset,
                                             outputGain: outputGain,
                                             outputYMin: outputYMin)
        let network = NeuralNetwork(data: data)
        network.constructNetwork()
        
        var predicted = [Float]()
        for tibShock in tibShocks {
            let input: [Float] = [Float(tibShock), Float(speed), Float(mass*9.81)]
            predicted.append(network.predict(input: input))
        }
        let result = Surge.sum(predicted) / Float(predicted.count)
        
        return Double(result)
    }
    
    static func getStrideLength(flightTime: Double, speed: Double) -> Double {
        
        return flightTime * (speed / 3.6)
    }
    
    static func getCadence(data:[Double], shocks:[Int], dataRate: Double) -> Double {
        let minuteElapsed = 60.0 * dataRate / Double(data.count)
        return Double(shocks.count)*minuteElapsed*2
    }
    
    static func getContactTime(strike:[Int], toeOff:[Int], dataRate: Double) -> Double {
        if (strike.count == 0 || toeOff.count == 0) {
            return 0
        }
        var contactTimes = [Double]()
        for i in 0..<min(toeOff.count, strike.count) {
            let idxDiff = toeOff[i] - strike[i]
            let time = Double(idxDiff)/dataRate
            contactTimes.append(time)
        }
        return contactTimes.reduce(0,+)/Double(contactTimes.count)
    }
    
    static func getFlightTime(strike:[Int], toeOff:[Int], dataRate:Double) -> Double {
        if (strike.count == 0 || toeOff.count == 0) {
            return 0
        }
        let strikeAndToeOff = Array(Set(strike).union(Set(toeOff))).sorted()
        var flightTimes = [Double]()
        for i in 0..<strikeAndToeOff.count-1 {
            let diff = strikeAndToeOff[i+1] - strikeAndToeOff[i]
            let time = Double(diff)/dataRate
            flightTimes.append(time)
        }
        return flightTimes.reduce(0,+)/Double(flightTimes.count)
    }
    
    static func getTibShock(data:[Double], dataRate:Double) -> [Int] {
        let tibShocks = findPeak(data: data, args: [Args.MinPeakHeight:2.0, Args.MinPeakDistance:0.5*dataRate])
        return tibShocks
    }

    
    static func getPeakAcceleration(data:[Double], dataRate:Double) -> [Int] {
        let accelerationPeaks = findPeak(data: data, args: [Args.MinPeakHeight:1.1, Args.MinPeakDistance:0.5*dataRate])
        return accelerationPeaks
    }
    
    static func getToeOff(data:[Double], shocks:[Int], dataRate: Double) -> [Int] {
        //let tibShocks = Set(shocks)
        if (shocks.count == 0) {
            return [Int]()
        }
        let invertedData = data.map { $0 * -1 }
        let localMinima = findPeak(data: invertedData, args: [:])
        let grandPeaks = (shocks + localMinima).sorted()
        var toeOff = [Int]()
        
        var localMins = [Int]()
        let shockPosInGrands = findPos(grandPeaks: grandPeaks, localPeaks: shocks)
        for posInGrand in shockPosInGrands {
            if posInGrand+5 < grandPeaks.count-1 {
                let nextFives = grandPeaks[posInGrand+1...posInGrand+5]
                localMins.append(nextFives.min { (a, b) -> Bool in
                    data[a] < data[b]
                    }!)
            }
            
        }
        
        for i in 0..<localMins.count-1 {
            let windowLow = findPosInGrandPeaks(grandPeaks: grandPeaks, localPeak: localMins[i])
            let windowUp = findPosInGrandPeaks(grandPeaks: grandPeaks, localPeak: localMins[i+1])
            let window = Array(grandPeaks[windowLow...windowUp])
            let diffs = window.map { $0 - localMins[i] }
            let logic = diffs.map { diff in Double(diff) > 0.1*dataRate }
            var finalMin = [Int]()
            for j in 0..<window.count {
                if logic[j] {
                    finalMin.append(window[j])
                }
            }
            if finalMin.count >= 3 {
                let firstThree = finalMin[0...2]
                toeOff.append(firstThree.min { (a, b) -> Bool in
                    data[a] < data[b]
                    }!)
            }
            
        }
        
        //let toeOff = tibShocks.intersection(grandPeaks)
        return toeOff
    }
    
    static func getFootStrike(data:[Double], shocks:[Int]) -> [Int] {
        if(shocks.count == 0) {
            return [Int]()
        }
        let invertedData = data.map { $0 * -1 }
        let localMinima = findPeak(data: invertedData, args: [:])
        
        var footStrike = [Int]()
        
        for shock in shocks {
            let temp = localMinima.filter { $0 < shock }
            if temp.count > 2 {
                let lastTwo = temp[temp.count-2..<temp.count]
                let minimum = lastTwo.min { (a, b) -> Bool in
                    data[a] < data[b]
                }
                footStrike.append(minimum!)
            }
            
        }
        
        return Array(footStrike)
    }
    
    // MARK: PRIVATE
    // findPeak: A generic function to find peaks in a data series
    
    private static func findPeak(data:[Double], args:[Args:Double]) -> [Int] {
        var minPeakProminence = -Double.infinity
        var minPeakHeight = -Double.infinity
        var minPeakDistance = 0.0
        var minPeakWidth = 0.0
        var maxPeakWidth = Double.infinity
        var threshold = 0.0
        
        for (arg, value) in args {
            switch arg {
            case .MinPeakDistance:
                minPeakDistance = value
            case .MinPeakHeight:
                minPeakHeight = value
            case .MinPeakProminence:
                minPeakProminence = value
                
            }
        }
        
        let sig = diffSig(diffs: diff(data: data))
        
        //let inflect = getInflect(diffs: sig)
        let max = getMax(diffs: diff(data: sig))
        
        let peaks = removeBelowMinPeakHeight(data: data, peaks: max, minPeakHeight: minPeakHeight)
        let filteredPeaks = findPeaksSeparatedByMoreThanMeanPeakDistance(data: data, peaks: peaks, minPeakDistance: minPeakDistance)
        return filteredPeaks
    }
    
    static private func diff(data:[Double]) -> [Double] {
        var result = [Double]()
        if data.count - 1 > 0 {
            for i in 1...data.count-1 {
                result.append(data[i] - data[i-1])
            }
        }
        return result
    }
    
    static private func diffSig(diffs:[Double]) -> [Double] {
        var result = [Double]()
        for diff in diffs {
            if diff < 0 {
                result.append(-1)
            } else {
                result.append(1)
            }
        }
        return result
    }
    
    static private func getInflect(diffs:[Double]) {
        
    }
    
    static private func getMax(diffs:[Double]) -> [Int] {
        var result = [Int]()
        if diffs.count - 1 > 0 {
            for i in 0...diffs.count-1 {
                if (diffs[i] < 0) {
                    result.append(i+1)
                }
            }
        }
        
        return result
    }
    
    static private func removeBelowMinPeakHeight(data:[Double], peaks:[Int], minPeakHeight: Double) -> [Int] {
        let newPeaks = peaks.filter{ data[$0] >= minPeakHeight }
        return newPeaks
    }
    
    static private func findPeaksSeparatedByMoreThanMeanPeakDistance(data: [Double], peaks: [Int],minPeakDistance: Double) -> [Int] {
        
        if (peaks.count == 0) {
            return [Int]()
        }
        
        var temp = [Int: Double]()
        for i in 0...peaks.count-1 {
            temp[peaks[i]] = data[peaks[i]]
        }
        let sortedTemp = temp.sorted(by: { $0.value > $1.value })
        var sortedIdx = [Int]()
        for (key, _) in sortedTemp {
            sortedIdx.append(key)
        }
        
        var iDelete = Array(repeating: false, count: sortedIdx.count)
        for i in 0...sortedIdx.count-1 {
            if !iDelete[i] {
                let cond1 = sortedIdx.map { Double($0) >= Double(sortedIdx[i]) - minPeakDistance }
                let cond2 = sortedIdx.map { Double($0) <= Double(sortedIdx[i]) + minPeakDistance }
                
                var tempDelete = [Bool]()
                for j in 0 ..< iDelete.count {
                    let cond = cond1[j] && cond2[j]
                    tempDelete.append(iDelete[j] || cond)
                }
                iDelete = tempDelete
                iDelete[i] = false
            }
        }
        
        var filteredPks = [Int]()
        for i in 0...iDelete.count-1 {
            if !iDelete[i] {
                filteredPks.append(sortedIdx[i])
            }
        }
        return filteredPks.sorted()
        
    }
    
    private static func findPosInGrandPeaks(grandPeaks: [Int], localPeak: Int) -> Int {
        for i in 0..<grandPeaks.count {
            if grandPeaks[i] == localPeak {
                return i
            }
        }
        return -1
    }
    
    private static func findPos(grandPeaks: [Int], localPeaks: [Int]) -> [Int] {
        var i = 0, j = 0
        var result = [Int]()
        while (i < grandPeaks.count && j < localPeaks.count) {
            if (grandPeaks[i] == localPeaks[j]) {
                result.append(i)
                i+=1
                j+=1
            } else if grandPeaks[i] < localPeaks[j] {
                i += 1
            } else {
                j += 1
            }
        }
        return result
        
    }
}
