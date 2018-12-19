package protocol

import (
	"go.uber.org/zap"
	"github.com/vulcanize/drawbridge/internal/logger"
)

var log *zap.SugaredLogger

func init() {
	log = logger.Logger.Named("protocol")
}