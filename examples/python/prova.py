#!/usr/bin/env python

# Qt tutorial 1.

import sys
import os

module_dir = "@MODULE_DIR@"

if module_dir[0] == '@':
	module_dir = os.getcwd ()

sys.path.insert (0, module_dir)

from qt import *
from Numeric import *
from pl import *
import pl
import math
import qplplot
from  qt import *
import threading

class  MenuExample(QWidget):

    def __init__( self, parent=None , name=None ):
       QWidget.__init__(self,parent,name)
       self.file = QPopupMenu();
       self.file.insertItem( "&Open",  self.open )
       self.file.insertItem( "&Run",  self.Run )

       menu =  QMenuBar( self );
       menu.insertItem( "&File", self.file )
     
       self.mle=QMultiLineEdit(self)
       
       self.mle.show()

       self.qpl=  qplplot.qplplot(self)
       self.resize(500,700)
       
      #  self.resizeQUIET()

       self.show()

       self.qpl.attiva()
  
       

    def  Run(self):
       self.qpl.set_stream()
       exec(str(self.mle.text()), globals(),globals())

  
       
#       p.rotate( -ang )
       
       
#       p.drawRect( QRect(33, -4, 15, 8) )

    def mouseMoveEvent ( qmev ) :
        print "MOVE IN PYTHON"

    def resizeQUIET(self):
          self.mle.resize(self.width(), self.height()/3   )
          self.qpl.move(0,self.mle.y()+self.mle.height() +10)
          self.qpl.resize(self.width(), (2*self.height())/3-20   )
          print "FINE "
          
    def resizeEvent(self,qrev):
         print "resize in python"
         timer =  QTimer( self )
 	 self.connect( timer, SIGNAL("timeout()"), self.resizeQUIET )
 	 timer.start( 0, 1)





    def  open(self):
         self.command=str((QFileDialog.getOpenFileName(".","*.py",)))
         print self.command
         f=open(self.command,"r")
         self.command=f.read()
         print self.command
         self.mle.setText(self.command)


#pl.semaphore=threading.Semaphore()
#pl.owner=None

a = QApplication(sys.argv)

w=MenuExample()

# graph=qplplot.qplplot()

a.setMainWidget(w)
# graph.ciao()
# disegna(graph)
# graph.show()


a.exec_loop()








