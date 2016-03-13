# coding: UTF-8

puts __FILE__

picnic_1_tiles_text = <<TILES
################################################################################
################################################################################
################################################################################
################################################################################
################################################################################
################################################################################
################################################################################
################################################################################
###AAAAAAAAAAAAA ###############################################################
###AAAAAAAAAAAAA  ##############################################################
###AAAAAAAAAAAAA      ##########################################################
###AAAAAAAAAAAAA       #########################################################
###AAAAAAAAAAAAA        ########################################################
###AAAAAAAAAAAAA         #######################################################
###AAAAAAAAAAAA           ######################################################
###AAAAAAAAAAAA            #####################################################
###AAAAAAAAAAA               ###################################################
###AAAAAAAAAA                       ############################################
###AAAAAAAAA                           #########################################
###AAAAAAAA  B                               ###################################
###AAAAAA                                        ###############################
###AAAA                                               ##########################
###AA                                                         ##################
###                                                              ###############
###                                                                    #########
###                                                                          ###
###                                                                          ###
###                                                                          ###
###                                                                          ###
###                                                                          ###
###                                                                          ###
###                                                                          ###
###                                                                          ###
###                                                                          ###
###                                                                          ###
###                                                                          ###
###                                                                          ###
###                                                                          ###
###                                                                          ###
###                                                                          ###
###                                                                          ###
###                                                                          ###
###                                                                          ###
###                                                                          ###
###                                                                          ###
###                                                                          ###
####                                                                         ###
####                                                                         ###
####                                                                         ###
####                                                                         ###
#####                                                              X         ###
#####                                                                        ###
#####                                                                        ###
#####                                                                        ###
######                                                                       ###
######                                                                       ###
######                                                                       ###
################################################################################
################################################################################
################################################################################
TILES

create_area('picnic_1', 'picnic', picnic_1_tiles_text)


picnic_2_tiles_text = <<TILES
################################################################################
################################################################################
################################################################################
################################################################################
################################################################################
################################################################################
################################################################################
################################################################################
################################################################################
################################################################################
################################################################################
################################################################################
######################     #####################################################
######################     #####################################################
######################      ####################################################
#####################        ###################################################
#####################         ##################################################
#####################           ################################################
####################                                   ###########CCCCCCCCCCCCC#
###################                                      #########CCCCCCCCCCCCC#
##################                                                CCCCCCCCCCCCC#
#################                                                  CCCCCCCCCCCC#
##############                                                      CCCCCCCCCCC#
##############                                                       CCCCCCCCCC#
##########                                                            CCCCCCCCC#
#######                                                             D  CCCCCCCC#
####                                                                    CCCCCCC#
###                                                                      CCCCCC#
###                                                                        CCCC#
###                                                                          ###
###                                                                          ###
###                                                                          ###
###                                                                          ###
###                                                                          ###
###                                                                          ###
###                                                                          ###
###                                                                          ###
###                                                                          ###
###                                                                          ###
###                                                                          ###
###                                                                          ###
###                                                                          ###
###                                                                          ###
###                                                                          ###
#BBB                                                                         ###
#BBBBB                                                                       ###
#BBBBBBB                                                                     ###
#BBBBBBBBB   A                                                               ###
#BBBBBBBBBBB                                                                 ###
#BBBBBBBBBBBB                                                                ###
#BBBBBBBBBBBBB                                                               ###
#BBBBBBBBBBBBBB                                                              ###
#BBBBBBBBBBBBBBB                                                             ###
#BBBBBBBBBBBBBBBB                                                            ###
#BBBBBBBBBBBBBBBBB                                                           ###
#BBBBBBBBBBBBBBBBBB                                                          ###
#BBBBBBBBBBBBBBBBBB                                                          ###
#BBBBBBBBBBBBBBBBBBB############################################################
#BBBBBBBBBBBBBBBBBBB############################################################
################################################################################
TILES

create_area('picnic_2', 'picnic', picnic_2_tiles_text)


picnic_3_tiles_text = <<TILES
################################################################################
################################################################################
################################################################################
################################################################################
################################################################################
################################################################################
################################################################################
################################################################################
################################################################################
################################################################################
################################################################################
################################################################################
#####################################              #############################
##############################                          ########################
#########################                                      #################
###################                                                 ############
###########                                                              #######
#######                                                                    #####
###                                                                         ####
###                                                                          ###
###                                                                          ###
###                                                                          ###
###                                                                          ###
###                                                                          ###
###                                                                          ###
###                                                                          ###
###                                                                          ###
###                                                                          ###
###                                                                          ###
###                                                                          ###
###                                                                          ###
###                                                                          ###
###                                                                          ###
###                                                                          ###
###                                                                          ###
###                                                                          ###
###                                                                          ###
###                                                                          ###
###                                                                          ###
###                                                                          ###
###                                                                          ###
###                                                                          ###
###                                                                          ###
###                                                                          ###
###                                                                          ###
###                                                                          ###
###                                                                          ###
###                                                                          ###
###                                                                      DDDDDD#
###                                                                     DDDDDDD#
###                                                                   DDDDDDDDD#
###                                                               C  DDDDDDDDDD#
###                                                                DDDDDDDDDDDD#
###                                                              DDDDDDDDDDDDDD#
###                                                             DDDDDDDDDDDDDDD#
###                                                            DDDDDDDDDDDDDDDD#
###                                                           DDDDDDDDDDDDDDDDD#
##############################################################DDDDDDDDDDDDDDDDD#
################################################################################
################################################################################
TILES

create_area('picnic_3', 'picnic', picnic_3_tiles_text, :village)