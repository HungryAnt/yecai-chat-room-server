LogUtil.info __FILE__

school_ground_tiles_text = <<TILES
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
################################################################################
################################################################################
################################################################################
################################################################################
################################################################################
###AAAAA########################################################################
###AAAAA########################################################################
###AAAAA########################################################################
###AAAAA########################################################################
###     B        ######################################                      ###
###                ################################                          ###
###                  ##########################                              ###
###                   ####################                                   ###
###                    ##############                                        ###
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
####################                                                         ###
####################                                                         ###
####################                                                         ###
####################                                                         ###
########################                                                     ###
########################                                                     ###
########################                                                     ###
########################                                                     ###
########################                                                     ###
########################                                                     ###
########################                                           X         ###
########################                                                     ###
########################                                                     ###
########################                                                     ###
########################                                                     ###
################################################################################
TILES


create_area('ground', 'school', school_ground_tiles_text)


school_lobby_tiles_text = <<TILES
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
############################BBBBBBBBBBBBBB        ##############################
############################BBBBBBBBBBBBBB         #############################
############################BBBBBBBBBBBBBB          ############################
############################BBBBBBBBBBBBBB    A     ############################
############################BBBBBBBBBBBBBB          ############################
###########################                         ############################
##########################                           ###########################
#########################                            ###########################
########################                              ##########################
#######################                               ##########################
######################                                 #########################
#####################                                  #########################
####################                                    ########################
###################                                      #######################
##################                                        ######################
#################                                          #####################
################                                            ####################
###############                                              ###################
##############                                                ##################
#############                                                  #################
############                                                    ################
###########                                                      ###############
##########                                                        ##############
#########                                                          #############
########                                                               CCCCCCCC#
#######                                                                 CCCCCCC#
######                                                                D  CCCCCC#
#####                                                                     CCCCC#
####                                                                       CCCC#
###                                                                          CC#
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
################################################################################
TILES

create_area('lobby', 'school', school_lobby_tiles_text)

school_room_tiles_text = <<TILES
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
########################             ###########################################
########################             ###########################################
###      ###############              ##########################################
###      ###############              ##########################################
###      ###############               #########################################
###      ########                      #########################################
###                                     ########################################
###                                      #######################################
###                                       ######################################
###                                         ####################################
###                                          #######################       #####
###                                                                        #####
###                                                                        #####
###                                                                        #####
###                                                                        #####
###                                                                        #####
###                                                                        #####
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
###DDDD                                                                      ###
###DDDDD                                                                     ###
###DDDDDD                                                                    ###
###DDDDDDD                                                                   ###
###DDDDDDDDC                                                                 ###
###DDDDDDDD                                                                  ###
###DDDDDDDDD                                                                 ###
###DDDDDDDDD                                                                 ###
###DDDDDDDDDD                                                                ###
###DDDDDDDDDD                                                                ###
################################################################################
TILES

create_area('room', 'school', school_room_tiles_text)
